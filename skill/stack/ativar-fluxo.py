"""Publica a versão atual do fluxo importado no n8n 1.x.

O import:workflow do n8n não cria a linha em workflow_history, e a ativação
(update:workflow --active=true) aponta pra ela (FOREIGN KEY constraint failed).
Cada rodada gera uma versão nova, então reinstalar também atualiza o fluxo.
Uso: python3 ativar-fluxo.py <database.sqlite> <id>
"""
import sqlite3, sys, uuid

banco, fluxo = sys.argv[1], sys.argv[2]
c = sqlite3.connect(banco)
if not c.execute("select 1 from workflow_entity where id = ?", (fluxo,)).fetchone():
    sys.exit("fluxo não encontrado no banco do n8n")
versao = str(uuid.uuid4())
c.execute("update workflow_entity set versionId = ? where id = ?", (versao, fluxo))
c.execute(
    """insert into workflow_history
       (versionId, workflowId, authors, createdAt, updatedAt, nodes, connections, name, autosaved)
       select versionId, id, 'Core OS', datetime('now'), datetime('now'), nodes, connections, name, 0
       from workflow_entity where id = ?""",
    (fluxo,),
)
c.commit()
print("ok")
