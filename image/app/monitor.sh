#!/bin/sh

while :
do
    if [ ! -z "$(ls /audit-rules)" ]; then
        cp /audit-rules/* /node/etc/audit/rules.d/
    fi
    
    if [ ! -z "$(ls /audisp-plugins)" ]; then
        cp /audisp-plugins/* /node/etc/audisp/plugins.d/
    fi

    if [ ! -z "$(ls /oms-config)" ]; then
        cp /oms-config/* /node/etc/opt/microsoft/omsagent/${LOG_ANALYTICS_WORKSPACE_ID}/conf/omsagent.d/
    fi

    chroot /node systemctl reload auditd
    sleep 30
done

