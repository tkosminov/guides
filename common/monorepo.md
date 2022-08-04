# Способы миграции в монорепозиторий

## git pull (с сохранением истории коммитов)

Создаем папку для монорепозитория и инициализируем его:

```bash
mkdir ~/monorepo && cd ~/monorepo

git init
```

Добавляем remote на другие репозитории:

```bash
git remote add ${FIRST_REPOSITORY} git@github.com:${GITHUB_USER}/${FIRST_REPOSITORY}.git

git remote add ${SECOND_REPOSITORY} git@github.com:${GITHUB_USER}/${SECOND_REPOSITORY}.git

...
```

Далее внутри каждого репозитория `${FIRST_REPOSITORY}`, `${SECOND_REPOSITORY}` и `т.д.` надо создать папки с соответсвующими названиями (`${FIRST_REPOSITORY}`, `${SECOND_REPOSITORY}` и `т.д.`). Затем переместить все содержимое репозиториев в эти папки.

Пример:

```bash
cd ~/${FIRST_REPOSITORY}

mkdir ${FIRST_REPOSITORY}
mv * ${FIRST_REPOSITORY}
```

А затем скачать (через `git pull`) эти репозитории внутри монорепозитория:

```bash
git pull ${FIRST_REPOSITORY} ${FIRST_REPOSITORY_BRANCH} --allow-unrelated-histories

git pull ${SECOND_REPOSITORY} ${SECOND_REPOSITORY_BRANCH} --allow-unrelated-histories

...
```

## git merge (с сохранением истории коммитов)

Создаем папку для монорепозитория и инициализируем его:

```bash
mkdir ~/monorepo && cd ~/monorepo

git init
```

Добавляем remote на другие репозитории:

```bash
git remote add ${FIRST_REPOSITORY} git@github.com:${GITHUB_USER}/${FIRST_REPOSITORY}.git

git remote add ${SECOND_REPOSITORY} git@github.com:${GITHUB_USER}/${SECOND_REPOSITORY}.git

...
```

Далее внутри каждого репозитория `${FIRST_REPOSITORY}`, `${SECOND_REPOSITORY}` и `т.д.` надо создать папки с соответсвующими названиями (`${FIRST_REPOSITORY}`, `${SECOND_REPOSITORY}` и `т.д.`). Затем переместить все содержимое репозиториев в эти папки.

Пример:

```bash
cd ~/${FIRST_REPOSITORY}

mkdir ${FIRST_REPOSITORY}
mv * ${FIRST_REPOSITORY}
```

```bash
git fetch ${FIRST_REPOSITORY}
git merge ${FIRST_REPOSITORY}/${FIRST_REPOSITORY_BRANCH} --allow-unrelated-histories

git fetch ${SECOND_REPOSITORY}
git merge ${SECOND_REPOSITORY}/${SECOND_REPOSITORY_BRANCH} --allow-unrelated-histories

...
```

## git read-tree (без сохранения истории коммитов)

Создаем папку для монорепозитория и инициализируем его:

```bash
mkdir ~/monorepo && cd ~/monorepo

git init
```

Добавляем remote на другие репозитории:

```bash
git remote add ${FIRST_REPOSITORY} git@github.com:${GITHUB_USER}/${FIRST_REPOSITORY}.git

git remote add ${SECOND_REPOSITORY} git@github.com:${GITHUB_USER}/${SECOND_REPOSITORY}.git

...
```

Cкачиваем репозитории:

```bash
git fetch ${FIRST_REPOSITORY}
git read-tree --prefix=./${FIRST_REPOSITORY} -u ${FIRST_REPOSITORY}/${FIRST_REPOSITORY_BRANCH}

git fetch ${SECOND_REPOSITORY}
git read-tree --prefix=./${SECOND_REPOSITORY} -u ${SECOND_REPOSITORY}/${SECOND_REPOSITORY_BRANCH}

...
```

## git subtree (с сохранением истории коммитов)

Создаем папку для монорепозитория и инициализируем его:

```bash
mkdir ~/monorepo && cd ~/monorepo

git init
```

Делаем первый пустой коммит:

```bash
git commit --allow-empty -n -m "Initial commit."
```

Cкачиваем репозитории:

```bash
git subtree add --prefix ${FIRST_REPOSITORY} git@github.com:${GITHUB_USER}/${FIRST_REPOSITORY}.git ${FIRST_REPOSITORY_BRANCH}

git subtree add --prefix ${SECOND_REPOSITORY} git@github.com:${GITHUB_USER}/${SECOND_REPOSITORY}.git ${SECOND_REPOSITORY_BRANCH}
...
```

Если надо подпуллиться:

```bash
git subtree pull --prefix=${FIRST_REPOSITORY} git@github.com:${GITHUB_USER}/${FIRST_REPOSITORY}.git ${FIRST_REPOSITORY_BRANCH}

git subtree pull --prefix=${SECOND_REPOSITORY} git@github.com:${GITHUB_USER}/${SECOND_REPOSITORY}.git ${SECOND_REPOSITORY_BRANCH}

...
```
