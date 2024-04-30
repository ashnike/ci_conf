import boto3
import os  
import yaml  

def generate_ec2_inventory():
    # Initialize Boto3 EC2 client
    ec2 = boto3.client('ec2')

    # Get all EC2 instances
    instances = ec2.describe_instances()

    # Initialize dictionary to store instances grouped by project
    project_instances = {}
    sonarqube_server_ip = None

    # Loop through reservations and instances to extract instance details
    for reservation in instances['Reservations']:
        for instance in reservation['Instances']:
            # Extract instance details
            instance_id = instance['InstanceId']
            public_ip = instance.get('PublicIpAddress')
            name_tag = next((tag['Value'] for tag in instance.get('Tags', []) if tag['Key'] == 'Name'), instance_id)
            project_tag = next((tag['Value'] for tag in instance.get('Tags', []) if tag['Key'] == 'Project'), 'default')
            
            # Check if instance is SonarQube server
            if project_tag.lower() == 'sonarqube':
                sonarqube_server_ip = public_ip

            # Construct instance details string
            if public_ip:
                # Use os.path.abspath to get the absolute path of the key pair file
                key_pair_file = os.path.join(os.path.dirname(__file__), f"{project_tag}.pem")
                instance_detail = f"{name_tag} ansible_host={public_ip} ansible_user=ubuntu ansible_port=22 ansible_ssh_private_key_file={key_pair_file}"
                # Add instance detail to project group
                project_instances.setdefault(project_tag, []).append(instance_detail)

    # Generate Ansible inventory file (ec2.ini)
    inventory_path = 'ansible/inventory/hosts.ini'  # Specify the full path
    with open(inventory_path, 'w') as f:
        # Write instance details grouped by project
        for project, instances in project_instances.items():
            f.write(f"[{project}]\n")
            for instance in instances:
                f.write(instance + "\n")
    
    # Load existing main.yaml content if it exists
    vars_path = 'ansible/playbooks/roles/sonarqube_server/vars/main.yaml'  # Specify the full path
    existing_vars = {}
    if os.path.exists(vars_path):
        with open(vars_path, 'r') as f:
            existing_vars = yaml.safe_load(f) or {}
    
    # Update values in main.yaml
    existing_vars['ansible_managed'] = 'Managed by Ansible. DO NOT EDIT.'
    existing_vars['postgres_password'] = 'admin123'
    existing_vars['sonar_db_name'] = 'sonarqube'
    existing_vars['sonar_db_password'] = 'sonar2314'
    existing_vars['sonar_db_user'] = 'sonar'
    existing_vars['sonar_scanner_version'] = '5.0.1.3006'
    existing_vars['sonar_version'] = '10.5.0.89998'

    # Update sonar_server_url value if SonarQube server IP is available
    if sonarqube_server_ip:
        existing_vars['sonar_server_url'] = f"http://{sonarqube_server_ip}:9000"

    # Write updated values to main.yaml
    with open(vars_path, 'w') as f:
        yaml.dump(existing_vars, f)

if __name__ == "__main__":
    generate_ec2_inventory()
