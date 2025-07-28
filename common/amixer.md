# [amixer](https://linux.die.net/man/1/amixer)

## Включить/выключить микрофон

```bash
amixer -c 1 sset Capture toggle
```

## Список

```bash
amixer -c 1 scontrols
```

## Получить инфу о текущем состоянии

```bash
amixer -c 1 sget ${CONTROL_NAME}
```

## Изменить состояние

```bash
amixer -c 1 sset ${CONTROL_NAME} ${ACTION_OR_VALUE}
```
