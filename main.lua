--[[
---
Projeto: Dotfiles Manager Simulator (Simulador de Gerenciador de Dotfiles)
Descrição: Uma ferramenta de linha de comando para simular o gerenciamento de
           arquivos de configuração (dotfiles). Ela permite adicionar, remover,
           listar e "sincronizar" arquivos de configuração em uma lista interna.
           Nenhuma operação real de arquivo é executada, é apenas uma simulação.
Bibliotecas necessárias: Nenhuma. Utiliza apenas as bibliotecas padrão do Lua.
Como executar: lua main.lua <comando> [argumento]

Comandos disponíveis:
  - add <caminho_do_arquivo>: Adiciona um arquivo à lista de rastreamento.
  - remove <caminho_do_arquivo>: Remove um arquivo da lista.
  - list: Lista todos os arquivos rastreados.
  - sync: Simula a sincronização dos arquivos.
  - help: Mostra esta mensagem de ajuda.

Exemplo de uso:
  lua main.lua add ~/.bashrc
  lua main.lua list
  lua main.lua sync
---
--]]

-- Tabela para armazenar os caminhos dos nossos "dotfiles" gerenciados.
-- Em um aplicativo real, isso seria lido e escrito em um arquivo.
local dotfiles = {
  "~/.config/nvim/init.lua",
  "~/.tmux.conf"
}

-- Módulo para gerenciar a lista de dotfiles
local Manager = {}

--- Verifica se um valor existe em uma tabela (lista).
-- @param list A tabela para pesquisar.
-- @param value O valor a ser procurado.
-- @return boolean Verdadeiro se o valor for encontrado, falso caso contrário.
local function list_contains(list, value)
  for _, v in ipairs(list) do
    if v == value then
      return true
    end
  end
  return false
end

--- Adiciona um novo arquivo de configuração à lista.
-- @param path O caminho para o arquivo a ser adicionado.
function Manager.add(path)
  if not path then
    print("Erro: O comando 'add' requer um caminho de arquivo.")
    print("Uso: lua main.lua add <caminho_do_arquivo>")
    return
  end

  if list_contains(dotfiles, path) then
    print("Aviso: O arquivo '" .. path .. "' já está sendo gerenciado.")
  else
    table.insert(dotfiles, path)
    print("Sucesso: '" .. path .. "' adicionado à lista de gerenciamento.")
  end
end

--- Remove um arquivo de configuração da lista.
-- @param path O caminho para o arquivo a ser removido.
function Manager.remove(path)
  if not path then
    print("Erro: O comando 'remove' requer um caminho de arquivo.")
    print("Uso: lua main.lua remove <caminho_do_arquivo>")
    return
  end
  
  local found_index = -1
  for i, filepath in ipairs(dotfiles) do
    if filepath == path then
      found_index = i
      break
    end
  end

  if found_index ~= -1 then
    table.remove(dotfiles, found_index)
    print("Sucesso: '" .. path .. "' removido da lista.")
  else
    print("Erro: O arquivo '" .. path .. "' não foi encontrado na lista.")
  end
end

--- Lista todos os arquivos atualmente gerenciados.
function Manager.list()
  if #dotfiles == 0 then
    print("Nenhum dotfile está sendo gerenciado no momento.")
    return
  end

  print("Dotfiles gerenciados:")
  for i, path in ipairs(dotfiles) do
    print(string.format("  [%d] %s", i, path))
  end
end

--- Simula a sincronização dos arquivos.
function Manager.sync()
  if #dotfiles == 0 then
    print("Nada para sincronizar. Adicione arquivos primeiro com o comando 'add'.")
    return
  end

  print("Iniciando simulação de sincronização...")
  for _, path in ipairs(dotfiles) do
    -- Simula um pequeno atraso para tornar mais "realista"
    -- (Não há uma função sleep padrão, então vamos apenas imprimir)
    print("  -> Sincronizando " .. path .. " ... OK")
  end
  print("Sincronização simulada concluída com sucesso!")
end

--- Mostra as instruções de uso.
function Manager.help()
  print("Simulador de Gerenciador de Dotfiles em Lua")
  print("------------------------------------------")
  print("Uso: lua main.lua <comando> [argumento]\n")
  print("Comandos:")
  print("  add <caminho>    Adiciona um arquivo para ser gerenciado.")
  print("  remove <caminho> Remove um arquivo da lista.")
  print("  list             Lista todos os arquivos gerenciados.")
  print("  sync             Simula a sincronização dos arquivos.")
  print("  help             Mostra esta mensagem de ajuda.")
end

-- Tabela de despacho de comandos para mapear strings de comando para funções.
local commands = {
  add = Manager.add,
  remove = Manager.remove,
  list = Manager.list,
  sync = Manager.sync,
  help = Manager.help
}

-- Ponto de entrada principal do script
local function main()
  -- O primeiro argumento da linha de comando é o comando
  local command_name = arg[1]
  local command_arg = arg[2]

  if not command_name then
    Manager.help()
    return
  end

  local func = commands[command_name]

  if func then
    func(command_arg)
  else
    print("Erro: Comando '" .. command_name .. "' desconhecido.")
    Manager.help()
  end
end

-- Executa a função principal
main()
