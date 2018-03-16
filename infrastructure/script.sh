#!/bin/sh

echo -e "\n"
echo "************************************************"
echo '                Terraform Download              '
echo "************************************************"
echo -e "\n"

wget https://releases.hashicorp.com/terraform/0.11.3/terraform_0.11.3_linux_386.zip

unzip -o terraform_0.11.3_linux_386.zip

rm -rf terraform_0.11.3_linux_386.zip

echo -e "\n"
echo "************************************************"
echo '                Terraform Init                 '
echo "************************************************"
echo -e "\n"

./terraform init

echo -e "\n"
echo "************************************************"
echo '                Terraform Apply                 '
echo "************************************************"
echo -e "\n"

./terraform apply \
           -auto-approve \
           -var client_id=${client_id} \
           -var client_secret=${client_secret} \
           -var subscription_id=${subscription_id} \
           -var tenant_id=${tenant_id}



echo -e "\n"
echo "************************************************"
echo '                  Terraform Show                '
echo "************************************************"
echo -e "\n"

./terraform show


echo -e "\n"
echo "************************************************"
echo '                Creating tfvars file            '
echo "************************************************"
echo -e "\n"

./terraform output | sed -ne 's/\(.*\) = \(.*\)/\1="\2"/p' > ../vm/infra-output.tfvars
./terraform output -json > ../vm/infra-output.json
