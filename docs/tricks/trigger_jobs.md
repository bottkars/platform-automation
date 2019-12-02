# tricks to make life easier

```bash
PIPELINE=pcfsc2
TARGET=RandD

PIPELINE=pcfazurestack
TARGET=control
fly -t ${TARGET} jobs -p ${PIPELINE} | grep get  | cut -f 1 -d " " | xargs -I{} fly -t ${TARGET} tj -j ${PIPELINE}/{}

```

``
fly -t ${TARGET} jobs -p ${PIPELINE} | grep upload  | cut -f 1 -d " " | xargs -I{} fly -t ${TARGET} tj -j ${PIPELINE}/{}
```

```bash
fly -t ${TARGET} jobs -p ${PIPELINE} | grep configure  | cut -f 1 -d " " | xargs -I{} fly -t ${TARGET} tj -j ${PIPELINE}/{}
```


```bash
fly -t ${TARGET} jobs -p ${PIPELINE} | grep upload  | cut -f 1 -d " " | xargs -I{} fly -t ${TARGET} pj -j ${PIPELINE}/{}
```
