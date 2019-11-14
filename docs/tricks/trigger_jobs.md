# tricks to make life easier

```bash
PIPELINE=pcfsc2
TARGET=RandD
fly -t ${TARGET} jobs -p ${PIPELINE} | grep get  | cut -f 1 -d " " | xargs -I{} fly -t ${TARGET} tj -j ${PIPELINE}/{}

```

```bash

fly -t ${TARGET} jobs -p ${PIPELINE} | grep upload  | cut -f 1 -d " " | xargs -I{} fly -t ${TARGET} tj -j ${PIPELINE}/{}
```