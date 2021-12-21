let s:dein_repo_path = './repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_path)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_path
  endif
  execute 'set runtimepath^='. fnamemodify(s:dein_repo_path, ':p')
endif

call dein#begin('./')

call dein#add('mfussenegger/nvim-dap')
call dein#add('nvim-treesitter/nvim-treesitter')
call dein#add('rcarriga/nvim-dap-ui')
call dein#add('leoluz/nvim-dap-go')
call dein#add('vim-test/vim-test')
call dein#add('theHamsta/nvim-dap-virtual-text')


call dein#end()

filetype plugin indent on
syntax enable

if dein#check_install()
  call dein#install()
endif


lua << EOF
  require'dapui'.setup()
  require'dap-go'.setup()
  require'nvim-dap-virtual-text'.setup()

  require'dap'.listeners.before['event_initialized']['custom'] = function(session, body)
    require'dapui'.open()
  end

  require'dap'.listeners.before['event_terminated']['custom'] = function(session, body)
    require'dapui'.close()
  end

  Dap = {}
  Dap.vim_test_strategy = {
    go = function(cmd)
      local test_func = string.match(cmd, "-run '([^ ]+)'")
      local path = string.match(cmd, "[^ ]+$")
      path = string.gsub(path, "/%.%.%.", "")

      configuration = {
        type = "go",
        name = "nvim-dap strategy",
        request = "launch",
        mode = "test",
        program = path,
        args = {},
      }

      if test_func then
        table.insert(configuration.args, "-test.run")
        table.insert(configuration.args, test_func)
      end

      if path == nil or path == "." then
        configuration.program = "./"
      end

      return configuration
    end,
  }

  function Dap.strategy()
    local cmd = vim.g.vim_test_last_command
    local filetype = vim.bo.filetype
    local f = Dap.vim_test_strategy[filetype]

    if not f then
      print("This filetype is not supported.")
      return
    end

    configuration = f(cmd)
    require'dap'.run(configuration)
  end
EOF

function! DapStrategy(cmd)
  echom 'It works! Command for running tests: ' . a:cmd
  let g:vim_test_last_command = a:cmd
  lua Dap.strategy()
endfunction

let g:test#custom_strategies = {'dap': function('DapStrategy')}
let g:test#strategy = 'dap'
