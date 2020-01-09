# Dapla Project (Statistics Norway Data Platform)

![DAPLA logo](doc/img/dapla-white.png)

This project aggregates dapla sources into a common development context.

Refer to the [localstack](dapla-localstack/README.md) for more information about how to spin up a local dapla runtime environment.


## Make targets

Run `make help` to see common commands.

```
update-all                     Checkout or update all related dapla repos
status-all                     Show a brief summary of local changes
```

## Development Environment

The provided "umbrella" `pom.xml` in this project allows you to conveniently open all dapla projects in your IDE.


## References

* [localstack](dapla-localstack/README.md)
* [dapla-catalog](https://github.com/statisticsnorway/dapla-catalog)
* [dapla-dataset-access](https://github.com/statisticsnorway/dataset-access)
* [dapla-dlp-project](https://github.com/statisticsnorway/dapla-dlp-project)
* [dapla-noterepo](https://github.com/statisticsnorway/dapla-noterepo)
* [dapla-spark](https://github.com/statisticsnorway/dapla-spark)
* [dapla-spark-plugin](https://github.com/statisticsnorway/dapla-spark-plugin)
