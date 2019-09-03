#!/bin/bash
# Meetup01
# Author: Ruan Oliveira
# Criacao de jobs no rundeck

# Variaveis
projeto_git="$1"
branch=TrainingDevOps
local=/var/lib/rundeck/scripts
path_projeto=$local/$branch
file="$local/jobs_ansible_$branch.yml"
rundeck="http://rundeck.laboratorio.cloud:4440"
token_rundeck="Q59NM8WoY7KVlWgsNLVSu8ABU2lig5Lf"
myip="$local/myip.txt"
iplocal=54.36.200.15

instala_pacotes(){
  sudo yum install ruby jq sshpass -y
}

limpa_saida(){
  # Limpeza do arquivo de job
  > $file
}

yamltojson(){
  yaml=($1)
  cat $yaml | ruby -ryaml -rjson -e 'puts JSON.pretty_generate(YAML.load(ARGF))'
}

cria_jobs_roles(){
  ## Criação de jobs de execução e teste em tasks específicas.
  for task in $(find $path_projeto/roles/*/*/tasks -name "*.yml" | sed -e 's/.yml//g');
  do
    task_f=$(echo "$task" | cut -d/ -f8- | sed -e 's,/, ,g')
  echo "- description: Execucao completa da task \"$task_f\"
  group: $branch/Tarefas/Execucao
  name: \"$task_f\"
  nodeFilterEditable: true
  nodefilters:
    dispatch:
      excludePrecedence: true
      keepgoing: false
      rankOrder: ascending
      successOnEmptyNodeFilter: false
      threadcount: 1
    filter: \".*\"
  nodesSelectedByDefault: false
  sequence:
    commands:
    - configuration:
        ansible-base-dir-path: $path_projeto
        ansible-become: 'false'
        ansible-disable-limit: 'false'
        ansible-extra-param: -i $path_projeto/inventory
        ansible-playbook: $task.yml
      nodeStep: false
      type: com.batix.rundeck.plugins.AnsiblePlaybookWorkflowStep"
  done

}

cria_job_dinamico(){

  busca_tags(){
    for file in $(ls $path_projeto/roles/*/*/tasks/*.yml);
    do
      yamltojson $file | jq -r '.[].tags[]' 2> /dev/null | sort | uniq
    done
  }
  tags=$(busca_tags | sort | uniq | sed -e 's/^/    - /g')

  list_playbook=$(ls $path_projeto/*.yml)
  playbook=$(echo "$list_playbook" | sort | uniq | sed -e 's/^/    - /g')

  echo "- description: 'Job para execução de Playbook Ansible.'
  executionEnabled: true
  group: $branch/Procedimentos
  id: 0e6659e5-1dac-4d0c-be0a-b0a0fd78f2a6
  loglevel: INFO
  name: Execução de playbooks
  nodeFilterEditable: true
  nodefilters:
    dispatch:
      excludePrecedence: true
      keepgoing: false
      rankOrder: ascending
      successOnEmptyNodeFilter: false
      threadcount: 1
    filter: \".*\"
  nodesSelectedByDefault: false
  options:
  - delimiter: ','
    description: Selecione e/ou insira os playbooks desejados para execuções completas do Playbook.
    multivalueAllSelected: false
    multivalued: true
    name: Playbook
    required: true
    values:
$playbook
  orchestrator:
    configuration:
      count: '1'
    type: subset
  scheduleEnabled: true
  sequence:
    commands:
    - configuration:
        ansible-base-dir-path: $path_projeto
        ansible-become: 'false'
        ansible-disable-limit: 'false'
        ansible-extra-param: -i $path_projeto/inventory
        ansible-playbook: \${option.Playbook}
      nodeStep: false
      type: com.batix.rundeck.plugins.AnsiblePlaybookWorkflowStep
    keepgoing: false
    strategy: node-first
  uuid: 0e6659e5-1dac-4d0c-be0a-b0a0fd78f2a6"

}

cria_job_inicial(){
  echo "- description: 'Job para criação de jobs com base em projeto ansible do GIT.'
  executionEnabled: true
  group: Ambiente
  id: aa3e1e8b-a17c-4dca-876f-63b1dadba7ff
  loglevel: INFO
  name: Job inicial
  nodeFilterEditable: true
  options:
  - description: Insira a branch do projeto GIT.
    name: Branch
  - description: Insira a URL do projeto GIT.
    name: GIT
    required: true
  orchestrator:
    configuration:
      count: '1'
    type: subset
  scheduleEnabled: true
  sequence:
    commands:
    - exec: sudo /var/lib/rundeck/scripts/gerador_jobs_rundeck.sh
    keepgoing: false
    strategy: node-first
  uuid: aa3e1e8b-a17c-4dca-876f-63b1dadba7ff"
}

job_import(){
  jobs=($1)
  api="api/14/project/Meetup01/jobs/import?format=yaml&dupeOption=update&uuidOption=preserve"
  sucesso="Arquivo com definicoes de jobs importado com sucesso!"
  falha="Nao foi possivel importar jobs. Tente executar novamente com 'vagrant provision rundeck'."
  curl -X "POST" -H "Accept: application/yaml" -H "Content-Type: application/yaml" -H "X-Rundeck-Auth-Token:$token_rundeck" "$rundeck/$api" --data-binary @"$jobs" && echo $sucesso || echo $falha
}

main(){
  p_rundeck=/var/rundeck/projects/DevOps_BB/etc/project.properties
  # Instala pacotes pre-requisitos
  #instala_pacotes;

  # Limpa saida de escrita dos jobs
  limpa_saida && echo "Realizado limpeza do arquivo de jobs.";

  #Cria ou atualiza repositorio
  #cria_repositorio >> /dev/null && echo "Repositorio GIT importado com sucesso" || echo "Nao foi possivel importar repositorio GIT. Verifique sua conexao com a rede local.";

  #if [ "$branch" == "develop" ];
  #then
  #configura_hosts $iplocal && echo "Hosts configurados na branch $branch." || echo "Erro ao configurado hosts em $branch."
  #fi

  #configura know Hosts
  #known_hosts=/var/lib/rundeck/.ssh/known_hosts
  #grep -q "[$iplocal]:2221" $known_hosts && echo "Ja existe chave ssh no known_hosts" || ssh-keyscan -p 2221 $iplocal >> $known_hosts && echo "Adicionado $iplocal:2221 no known_hosts"
  #grep -q "[$iplocal]:2222" $known_hosts && echo "Ja existe chave ssh no known_hosts" || ssh-keyscan -p 2222 $iplocal >> $known_hosts && echo "Adicionado $iplocal:2222 no known_hosts"

  #Cria nodes do projeto
  #grep -q -w "resources.source.2" $p_rundeck && echo "Ja existe nodes!" || cria_resource_nodes >> $p_rundeck && echo "Nodes Ansible branch $branch criados.";

  #Ajuste de permissoes
  chown -R rundeck.rundeck $path_projeto
  chmod -R 664 $path_projeto/inventory

  # Configura jobs
  if [ -e "$path_projeto" ];
  then
    cria_job_inicial >> $file
    cria_jobs_roles >> $file
    cria_job_dinamico >> $file
  else
    echo "Nao existe projeto para criacao de jobs Ansible. Criando repositorio local..."
    cria_repositorio;
    cria_job_inicial >> $file
    cria_jobs_roles >> $file
    cria_job_dinamico >> $file
  fi
  # Cria tudao
  if [ -f $file ];
  then
    api=$(wget -q $rundeck/user/login && echo 1 || echo 0)
    while [ "$api" == 0 ];
      do echo "API do Rundeck ainda não está disponível. Aguardando 10s...";
      sleep 10
      api=$(wget -q $rundeck/user/login && echo 1 || echo 0);
      if [ "$api" == 1 ];
        then
          break;
      fi;
    done
    job_import $file;
  else
    echo "Não existe arquivo para importação!"
  fi

}

main;
