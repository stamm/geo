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

```lang=bash
cp config/database.example.yml config/database.yml
# Исправить настройки подключения
bundle install
rake db:create
rake db:migrate
# Заполнить тестовыми данными Москву и Питер
rake db:sample_data
```

## Тесты

```lang=bash
rake db:create RAILS_ENV=test
rake db:migrate RAILS_ENV=test
bundle exec guard
#press enter
```



