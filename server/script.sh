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

./terraform apply -var-file=data.tfvars -var-file=image.tfvars -var-file=vm.tfvars -var-file=tag.tfvars -var-file=cred.tfvars -auto-approve
           

echo -e "\n"
echo "************************************************"
echo '                  Terraform Show                '
echo "************************************************"
echo -e "\n"

./terraform show



echo -e "\n"
echo "************************************************"
echo '                Creating Output.json            '
echo "************************************************"
echo -e "\n"


./terraform output -json > vm-output.json
./terraform output  > vm-output.txt
