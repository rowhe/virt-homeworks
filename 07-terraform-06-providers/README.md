# Домашнее задание к занятию "7.6. Написание собственных провайдеров для Terraform."

Бывает, что 
* общедоступная документация по терраформ ресурсам не всегда достоверна,
* в документации не хватает каких-нибудь правил валидации или неточно описаны параметры,
* понадобиться использовать провайдер без официальной документации,
* может возникнуть необходимость написать свой провайдер для системы используемой в ваших проектах.   

## Задача 1. 
Давайте потренируемся читать исходный код AWS провайдера, который можно склонировать от сюда: 
[https://github.com/hashicorp/terraform-provider-aws.git](https://github.com/hashicorp/terraform-provider-aws.git).
Просто найдите нужные ресурсы в исходном коде и ответы на вопросы станут понятны.  


1. Найдите, где перечислены все доступные `resource` и `data_source`, приложите ссылку на эти строки в коде на 
гитхабе.
   * Я искал таким образом:
     1. Открыл main.go в корневой директории провайдера
     2. Нашел блок `import` и строку `"github.com/hashicorp/terraform-provider-aws/internal/provider"` в нем.
     3. Пошел по указанному пути и выполнил команду:
   ```shell
      grep -i 'resource\|data_source' *
   ```
   * Получил вывод из которого следует, что блоки с `resource` `data_source` начинаются с 425 и 916 строки соответственно.
   ```shell
   dpopov@dpopov-test:~/virt-homeworks/07-terraform-06-providers/terraform-provider-aws/internal/provider$ grep -i -n 'resource\|data_source' *
   ...
   provider.go:425:                DataSourcesMap: map[string]*schema.Resource{
   provider.go:434:                        "aws_api_gateway_resource":    apigateway.DataSourceResource(),
   ...
   provider.go:916:                ResourcesMap: map[string]*schema.Resource{
   provider.go:917:                        "aws_accessanalyzer_analyzer":     accessanalyzer.ResourceAnalyzer(),
   ...
   ```
   * Ссылки на соответствующие строки:
     * [DataSourceMap](https://github.com/hashicorp/terraform-provider-aws/blob/bfd3afc96e96821a160fa21dcc236b7bca5a0c49/internal/provider/provider.go#L425)
     * [ResourceMap](https://github.com/hashicorp/terraform-provider-aws/blob/bfd3afc96e96821a160fa21dcc236b7bca5a0c49/internal/provider/provider.go#L916)
2. Для создания очереди сообщений SQS используется ресурс `aws_sqs_queue` у которого есть параметр `name`. 
* С каким другим параметром конфликтует `name`? Приложите строчку кода, в которой это указано.
  * Конфликта параметров в найденных функциях не нашел, либо не правильно искал, либо указанный конфликт уже пофиксили в коде.
  * Поиск при помощи `grep -i -n 'aws_sqs_queue' *` дал следующий результат:
  ```shell
   provider.go:877:                        "aws_sqs_queue": sqs.DataSourceQueue(),
   provider.go:2009:                       "aws_sqs_queue":        sqs.ResourceQueue(),
   provider.go:2010:                       "aws_sqs_queue_policy": sqs.ResourceQueuePolicy(),
   
  ```
* Какая максимальная длина имени?
  * Исследование найденной функции [`sqs.ResourceQueue()`](https://github.com/hashicorp/terraform-provider-aws/blob/19c666dbdaa06a886c1b9e610cfbf13ec72ff83a/internal/service/connect/queue.go#L55) дало показало ограничение на 127 знаков на название ресурса:
   ```shell
     "name": {
               Type:         schema.TypeString,
               Required:     true,
               ValidateFunc: validation.StringLenBetween(1, 127),
      }
   ```
* Какому регулярному выражению должно подчиняться имя? 
  * Ссылок на regex для `name` в функции [`sqs.ResourceQueue()`](https://github.com/hashicorp/terraform-provider-aws/blob/19c666dbdaa06a886c1b9e610cfbf13ec72ff83a/internal/service/connect/queue.go#L20) тоже не было обнаружено.
    
## Задача 2. (Не обязательно) 
В рамках вебинара и презентации мы разобрали как создать свой собственный провайдер на примере кофемашины. 
Также вот официальная документация о создании провайдера: 
[https://learn.hashicorp.com/collections/terraform/providers](https://learn.hashicorp.com/collections/terraform/providers).

1. Проделайте все шаги создания провайдера.
2. В виде результата приложение ссылку на исходный код.
3. Попробуйте скомпилировать провайдер, если получится то приложите снимок экрана с командой и результатом компиляции.   

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
