#!/bin/bash

MAGIC_OVERRIDE_CODE="
def my_run_line_magic(*args, **kwargs):
    g=globals()
    l={}
    for a in args:
        try:
            exec(str(a),g,l)
        except Exception as e:
            print('WARNING: %s\n   While executing this magic function code:\n%s\n   continuing...\n' % (e, a))
        else:
            g.update(l)

def my_run_cell_magic(*args, **kwargs):
    my_run_line_magic(*args, **kwargs)

get_ipython().run_line_magic=my_run_line_magic
get_ipython().run_cell_magic=my_run_cell_magic

"

NO_COLORS=--colors=NoColor
EXITCODE=0
NB_PATH=$1

NBNAME=$(basename "${NB_PATH}" .ipynb)
NBTESTSCRIPT=$(mktemp --suffix=.py)

echo "--------------------------------------------------------------------------------"
echo "STARTING: ${NBNAME}"
echo "--------------------------------------------------------------------------------"
echo "${MAGIC_OVERRIDE_CODE}" > "${NBTESTSCRIPT}"
jupyter nbconvert --to script "${NB_PATH}" --stdout >> "${NBTESTSCRIPT}"

echo "Running \"ipython ${NO_COLORS} ${NBTESTSCRIPT}\" on $(date)"
echo
time bash -c "ipython ${NO_COLORS} ${NBTESTSCRIPT}; EC=\$?; echo -------------------------------------------------------------------------------- ; echo DONE: ${NBNAME}; exit \$EC"
NBEXITCODE=$?
echo "EXIT CODE: ${NBEXITCODE}"
echo
EXITCODE=$((EXITCODE | $NBEXITCODE))
rm -f "${NBTESTSCRIPT}"

exit ${EXITCODE}
