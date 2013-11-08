# Демонстрационное приложение google maps + postgis

## Возможности

- Просмотр точек на карте
- Фильтрация по цене
- Возможность задать область для отображения точек только внутри этой области

## Требования

- ruby 2.0.0-p247
- postgresql
- postgis

## Настройка приложения

```bash
cp config/database.example.yml config/database.yml
# Исправить настройки подключения
bundle install
rake db:create db:migrate db:sample_data
```

## Тесты

```bash
rake db:create RAILS_ENV=test
rake db:migrate RAILS_ENV=test
bundle exec guard
#press enter
```



