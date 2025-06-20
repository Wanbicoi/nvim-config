return {
  'ludovicchabant/vim-gutentags',
  event = 'VeryLazy',
  config = function()
    vim.g.gutentags_file_list_command = 'rg --files'
    vim.g.gutentags_cache_dir = vim.fn.stdpath 'cache' .. '/vim-gutentags'
    --vim.g.gutentags_trace = true
    vim.g.gutentags_ctags_exclude = {
      '.git',
      '.hg',
      '.svn',
      '.pijul',
      '_darcs',
      'node_modules',
      'vendor',
      'venv',
      '__pypackages__',
      'packages',
      'Pods',
      'target',
      'build',
      'dist',
      'libs',
      'out',
      'bin',
      'obj',
      '*.o',
      '*.exe',
      '*.dll',
      '*.so',
      '*.dylib',
      '*.pyc',
      '__pycache__',
      '*.class',
      '*.jar',
      '*.war',
      '*.ear',
      '.next',
      'coverage',
      '*.log',
      '*.min.js',
      '*.min.css',
      '*.map',
      '*.lock',
      '*.json',
      '*.xml',
      '*.pdf',
      '*.doc',
      '*.docx',
      '*.svg',
      '*.png',
      '*.jpg',
      '*.jpeg',
      '*.gif',
      '*.ico',
      '*.swp',
      '*.swo',
      '*.bak',
      '*.tmp',
      '*.cache',
      '.DS_Store',
      '*.db',
      '*.yaml',
      '*.yml',
      '*.suo',
      '*.user',
      '*.sln',
    }
  end,
}
