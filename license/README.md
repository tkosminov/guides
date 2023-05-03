# Лицензии

* [Описание](https://www.gnu.org/licenses/license-list.ru.html)
* [Примеры на github](https://github.com/github/choosealicense.com/tree/gh-pages/_licenses)

## [GPL-3.0 (GNU General Public License)](./examples/GPL-3.0.md)

```yaml
permissions:
  - commercial-use
  - modifications
  - distribution
  - patent-use
  - private-use

conditions:
  - include-copyright
  - document-changes
  - disclose-source
  - same-license

limitations:
  - liability
  - warranty
```

Пользователь имеет право распространять ПО под этой лицензией, участвовать в его разработке или изменять различными способами. Но есть такое правило: любые изменения программы, сделанные пользователем и распространенные им, должны иметь исходный код этих изменений.

## [Apache License 2.0](./examples/Apache-2.0.md)

```yaml
permissions:
  - commercial-use
  - modifications
  - distribution
  - patent-use
  - private-use

conditions:
  - include-copyright
  - document-changes

limitations:
  - trademark-use
  - liability
  - warranty
```

Гибкая лицензия, которая имеет четкие права. Плюс в том, что они могут применяться к копирайтам и патентам. Некоторые из доступных прав: права безвозмездны, вечны, не эксклюзивны и глобальны. Если вы распространяете код, вы должны указать имя разработчика.

## [BSD (Berkeley Software Distribution)](./examples/BSD-Original.md)

```yaml
permissions:
  - commercial-use
  - modifications
  - distribution
  - private-use

conditions:
  - include-copyright

limitations:
  - liability
  - warranty
```

В этой лицензии не такие строгие правила, как в `GPL`. Разработчики должны выполнить несложные условия: указывать в документации, что в продукте используются разработки создателей оригинального программного обеспечения и не использовать имена (или названия) создателей этого ПО в рекламных целях без письменного согласия.

BSD-лицензий существует несколько видов. Наиболее используемые `New BSD/Modified BSD` и `Simplified BSD/FreeBSD`.

### [New BSD](./examples/BSD-New.md)

Лицензия `New BSD` разрешает распространять ПО с любой целью, не дает гарантий и не несет ответственности за последствия использования. Есть пункт в виде специального разрешения: нельзя использовать имена участников вашего проекта.

```yaml
permissions:
  - commercial-use
  - modifications
  - distribution
  - private-use

conditions:
  - include-copyright

limitations:
  - liability
  - warranty
```

### [Simplified BSD](./examples/BSD-Simplified.md)

```yaml
permissions:
  - commercial-use
  - modifications
  - distribution
  - private-use

conditions:
  - include-copyright

limitations:
  - liability
  - warranty
```

Между этими лицензиями единственное отличие: в `Simplified BSD` не ограничено использование имен.

## [LGPL-3.0 (GNU Lesser General Public License)](./examples/LGPL-3.0.md)

```yaml
permissions:
  - commercial-use
  - modifications
  - distribution
  - patent-use
  - private-use

conditions:
  - include-copyright
  - disclose-source
  - document-changes
  - same-license--library

limitations:
  - liability
  - warranty
```

Появилась в рамках проекта `GNU`. Дает больше прав, чем `GPL`. Главное отличие в том, что она позволяет использовать продукты `LGPL` в проектах, которые распространяются под другими лицензиями.

## [MIT (Massachusetts Institute of Technology License)](./examples/MIT.md)

```yaml
permissions:
  - commercial-use
  - modifications
  - distribution
  - private-use

conditions:
  - include-copyright

limitations:
  - liability
  - warranty
```

Очень короткая и достаточно свободная лицензия. Она разрешает использовать, копировать и модифицировать программное обеспечение на ваше усмотрение. ПО можно предоставлять бесплатно или даже продавать. Ограничений нет. Но есть ограничение в том, что ваше ПО должно сопровождаться лицензионным соглашением.

Программное обеспечение, которое лицензировано `MIT`, можно использовать в закрытых продуктах. Лицензия схожа с `BSD`. Но в `MIT` можно использовать название продукта и имена создателей в рекламных целях.

## [MPL-2.0 (Mozilla Public License)](./examples/MPL-2.0.md)

```yaml
permissions:
  - commercial-use
  - modifications
  - distribution
  - patent-use
  - private-use

conditions:
  - disclose-source
  - include-copyright
  - same-license--file

limitations:
  - liability
  - trademark-use
  - warranty
```

Содержит в себе черты `BSD` и `GPL`. Исходный код, скопированный или измененный под лицензией `MPL`, должен быть лицензирован по правилам `MPL`. Лицензия позволяет объединить его в одной программе с проприетарными (несвободными) файлами.

## [OSL-3.0 (Open Software License)](./examples/OSL-3.0.md)

```yaml
permissions:
  - commercial-use
  - distribution
  - modifications
  - patent-use
  - private-use

conditions:
  - include-copyright
  - disclose-source
  - document-changes
  - network-use-disclose
  - same-license

limitations:
  - trademark-use
  - liability
  - warranty
```

Лицензия открытых программ является лицензией свободных программ.

В последних версиях Лицензии открытых программ есть условие, по которому от распространителей требуется попытаться получить явное согласие на лицензию. Это значит, что распространение программ под OSL через обычные сайты FTP, пересылка изменений по обычным спискам рассылки или хранение программ в обычной системе контроля версий может расцениваться как нарушение лицензии и основание для отзыва у вас лицензии. Таким образом, Лицензия открытых программ сильно затрудняет разработку программ, применяющих обычные средства разработки свободных программ
