#!/bin/sh
set -eu

orchestrator=$(kubectl get po -l app=orchestrator -o name | head -1 | cut -d'/' -f2)
csv=$1
while [ -z "$(kubectl exec ${orchestrator} -- cat ${csv} 2>/dev/null | grep 'END CSV DATA')" ]; do
	echo "Waiting for network test complete..."
	sleep 10
done

echo "test done, writing result into file..."
echo "$(kubectl exec ${orchestrator} -- cat ${csv})" > $(basename ${csv})
echo