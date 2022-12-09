## Laravel Devenv

Docker Image For Laravel Development.

This Repository is inspired From [jackbrycesmith/laravel-caprover-template](https://github.com/jackbrycesmith/laravel-caprover-template)


## Ver8.1 Build

```
docker image build -t junzo/php-devenv:php8.1 --build-arg PHP_VERSION=8.1 .
```

### Test
```
docker run -p 8080:80 -v $(pwd)/app:/srv/app --name php8.1 junzo/php-devenv:php8.1
```

## Ver8.0 Build

```
docker image build -t junzo/php-devenv:php8.0 --build-arg PHP_VERSION=8.0 .
```

### Test
```
docker run -p 8080:80 -v $(pwd)/app:/srv/app --name php8.0 junzo/php-devenv:php8.0
```

## Ver7.4 Build

```
docker image build -t junzo/php-devenv:php7.4 --build-arg PHP_VERSION=7.4 .
```

### Test
```
docker run -p 8080:80 -v $(pwd)/app:/srv/app --name php7.4 junzo/php-devenv:php7.4
```

