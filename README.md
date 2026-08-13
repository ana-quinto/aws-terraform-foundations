# lab-terraform-foundations

Trilha prática de Terraform + AWS baseada na startup fictícia **ShopCloud**.  
Cada lab tem um contexto real, uma estrutura de arquivos definida e nenhum `main.tf` esperando por você.

---

## Pré-requisitos

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) configurado (`aws configure`)
- Credenciais com permissões suficientes para cada lab
- Adicione ao `.gitignore`:

```
*.tfstate
*.tfstate.backup
.terraform/
*.pem
```

---

## Estrutura

```
lab-terraform-foundations/
├── README.md
├── lab-01-ec2-nginx/        EC2 com nginx via user_data
├── lab-02-s3-website/       S3 static website com bucket policy
├── lab-03-lambda-api/       Lambda + Function URL consultando DynamoDB
├── lab-04-iam/              Usuário, grupo e policy com least privilege
└── lab-05-cloudwatch-sns/   CloudWatch Alarm + SNS por e-mail
```

---

## Fluxo padrão

O mesmo ciclo se repete em todos os labs:

```bash
terraform init       # baixa o provider e inicializa o backend
terraform plan       # mostra o que vai ser criado/modificado/destruído
terraform apply      # executa as mudanças (pede confirmação)
terraform output     # exibe os valores do outputs.tf
terraform destroy    # apaga tudo ao terminar — evita cobranças
```

---

## Labs

| # | Lab | Serviços | Tempo | Critério de sucesso |
|---|-----|----------|-------|---------------------|
| 01 | EC2 com nginx | EC2, Security Group | ~35 min | `curl http://<ip>` retorna 200 |
| 02 | S3 Static Website | S3, Bucket Policy | ~25 min | URL do site abre no navegador |
| 03 | Lambda API | Lambda, IAM, DynamoDB | ~45 min | `curl <function_url>` retorna JSON |
| 04 | IAM | IAM User, Group, Policy | ~35 min | `Scan` funciona, `DeleteItem` nega acesso |
| 05 | CloudWatch + SNS | CloudWatch Alarm, SNS | ~30 min | E-mail de alerta recebido com estado `ALARM` |

---

## Boas práticas

- **Nunca commite o tfstate** — ele pode conter senhas e chaves em texto claro
- **Nunca use `-auto-approve` na mão** — sempre leia o `plan` antes de aplicar
- **Sempre rode `terraform destroy`** ao terminar um lab para evitar cobranças
- **Consulte a documentação** antes de pedir ajuda: [registry.terraform.io](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
