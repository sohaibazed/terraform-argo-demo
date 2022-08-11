FROM alpine:latest

ENV TERRAFORM_VERSION=0.12.9
ENV TERRAFORM_PROVIDER_AZURERM=3.0.0
ENV TERRAFORM_PROVIDER_AZUREOPENSHIFT=0.0.3

RUN apk add --update bash curl openssl gcc musl-dev python3-dev libffi-dev openssl-dev cargo make py3-pip
RUN pip install --upgrade pip
RUN pip install azure-cli

ADD https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip ./

RUN unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin
RUN rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip


RUN ["addgroup", "-S", "myuser"]
RUN ["adduser", "-S", "-D", "-h", "/home/myuser", "-G", "myuser", "myuser"]
RUN ["mkdir", "-p", "/home/myuser/terraform.d/plugins/linux_amd64/"]

ADD https://releases.hashicorp.com/terraform-provider-azurerm/${TERRAFORM_PROVIDER_AZURERM}/terraform-provider-azurerm_${TERRAFORM_PROVIDER_AZURERM}_linux_amd64.zip ./
RUN unzip terraform-provider-azurerm_${TERRAFORM_PROVIDER_AZURERM}_linux_amd64.zip -d /home/myuser/terraform.d/plugins/linux_amd64/
RUN rm -f terraform-provider-azurerm_${TERRAFORM_PROVIDER_AZURERM}_linux_amd64.zip

ADD https://github.com/rh-mobb/terraform-provider-azureopenshift/releases/download/v${TERRAFORM_PROVIDER_AZUREOPENSHIFT}/terraform-provider-azureopenshift_${TERRAFORM_PROVIDER_AZUREOPENSHIFT}_linux_amd64.zip ./
RUN unzip terraform-provider-azureopenshift_${TERRAFORM_PROVIDER_AZUREOPENSHIFT}_linux_amd64.zip -d /home/myuser/terraform.d/plugins/linux_amd64/
RUN rm -rf terraform-provider-azureopenshift_${TERRAFORM_PROVIDER_AZUREOPENSHIFT}_linux_amd64.zip

ADD *.tf /home/myuser/

RUN chown myuser:myuser -R /home/myuser
RUN chmod +x -R /home/myuser/terraform.d/plugins/linux_amd64/
USER myuser
WORKDIR /home/myuser/
