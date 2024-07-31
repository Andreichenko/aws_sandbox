import os

# Get secret values from Jenkins
vultr_api_key = os.environ.get('VULTR_API_KEY')
do_access_key = os.environ.get('DO_ACCESS_KEY')
do_secret_key = os.environ.get('DO_SECRET_KEY')

# Path for configuration files
main_tf_path = 'terraform/vultr-dev/main.tf'
backend_tf_path = 'terraform/vultr-dev/backend.tf'

# Changes in config files
def replace_value(file_path, old_value, new_value):
    with open(file_path, 'r') as file:
        content = file.read()

    if old_value not in content:
        print(f"Error: Value {old_value} not found in file {file_path}.")
        return

    if new_value is None:
        print(f"Error: Value for variable {old_value} is not defined.")
        return

    updated_content = content.replace(old_value, new_value)

    with open(file_path, 'w') as file:
        file.write(updated_content)

# Variable changes in main.tf
replace_value(main_tf_path, '$VULTR_API_KEY', vultr_api_key)

# Value changes in backend.tf
replace_value(backend_tf_path, '$DO_ACCESS_KEY', do_access_key)
replace_value(backend_tf_path, '$DO_SECRET_KEY', do_secret_key)
