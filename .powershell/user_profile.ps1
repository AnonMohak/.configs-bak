# Prompt
oh-my-posh init pwsh --config "$HOME\.config\powershell\mohak.omp.json" | Invoke-Expression
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# tell WezTerm what runs in this tab (user var "prog"), so the tab bar does not read the process tree
function Set-WezTermProg([string]$name) {
    $b64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($name))
    [Console]::Write("`e]1337;SetUserVar=prog=$b64`a")
}

# at each prompt the shell is idle. oh-my-posh calls only its own Set-PoshContext (inside its module),
# so wrap its prompt function instead. Call it first, so it still sees $? of the last command
$global:OmpPrompt = $function:prompt
function global:prompt {
    $p = & $global:OmpPrompt
    Set-WezTermProg ''
    $p
}

# on Enter: send the name of the program, for example "nvim" or "cargo".
# cmdlets, functions and aliases (ls, z, cd) run inside pwsh, so send '' and keep the folder name
Set-PSReadLineKeyHandler -Key Enter -ScriptBlock {
    $line = $null; $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    $word = ($line.Trim() -split '\s+')[0]
    $cmd = if ($word) { Get-Command $word -ErrorAction SilentlyContinue | Select-Object -First 1 }
    if ($cmd.CommandType -eq 'Alias') { $cmd = $cmd.ResolvedCommand }
    $name = if ($cmd.CommandType -eq 'Application') { [IO.Path]::GetFileNameWithoutExtension($cmd.Name) } else { '' }
    Set-WezTermProg $name
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

# Alias 
Set-Alias vim nvim 
Set-Alias vi nvim
#set-Alias ll ls
set-Alias py python
set-Alias g git
set-Alias grep findstr
set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'
Remove-Item Alias:curl -ErrorAction SilentlyContinue
Remove-Item Alias:wget -ErrorAction SilentlyContinue
Remove-Item Alias:where -Force  -ErrorAction SilentlyContinue


# Custom
Write-Host -NoNewline "`e[2 q"

# Custom response for "hello there"
function hello-there {
    Write-Output "
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣴⣶⣶⣿⣿⣿⣿⣿⣿⣶⣶⣦⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠟⠛⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠛⠛⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀
⠀⠀⠀⠀⣸⣿⣿⣿⣿⣿⣿⡿⠟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⢿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀
⠀⠀⠀⣰⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣇⠀⠀⠀
⠀⠀⢠⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣿⡆⠀⠀
⠀⢀⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⡀⠀
⠀⣼⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⠀⠀⠀⠀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⣿⣿⣷⠀
⢰⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡇⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⡇
⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⢸⣧⠀⠀⠀⠀⠀⠀⢀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⡀⠀⠀⠀⠀⠀⠀⣸⡇⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿
⢻⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⣿⡄⠀⠀⠀⢀⣴⣿⣿⠿⢿⣿⠿⠿⠛⠛⠿⠿⢿⣿⠿⣿⣿⣦⡀⠀⠀⠀⢀⣿⠃⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⡟
⠀⢻⣿⣿⣿⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⢻⣷⡀⠀⠀⣾⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣷⡀⠀⢀⣾⡿⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣿⣿⣿⡿⠀
⠀⠀⢻⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠘⣿⣷⣄⢸⣿⣿⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⡇⢠⣾⣿⠇⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⡿⠁⠀
⠀⠀⠀⢻⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⣿⡿⠁⠀⠀
⠀⠀⠀⠀⠻⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⡟⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠘⢿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⡿⠃⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⠟⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠻⠿⢿⣿⣿⡿⠿⠟⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠟⠁⠀⠀⠀⠀

	

	General Kenobi! 

	

⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⠤⠒⠒⠉⠉⠉⠛⠳⢦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣷⡆⠀⠀⠀⠀⢀⡴⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⡈⠙⢦⡀⠀⠀⠀⣶⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⢧⠀⠀⠀⢀⣿⠀⠀⣰⠀⠀⠀⠀⠀⠀⠀⠀⠀⣷⠀⠀⢹⠀⠀⠀⡿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣠⠏⠸⡄⠀⣰⢺⡟⠀⠀⢿⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⠁⠀⢸⣆⠀⢀⡇⠘⢆⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢀⡤⠚⠁⠀⠀⡇⠀⣳⣼⠀⠀⠀⣾⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡆⠀⠀⣿⡀⢸⡇⠀⠀⠙⠦⡀⠀⠀⠀⠀⠀
⠀⠀⠀⢠⠖⠁⠀⠀⠀⠀⢀⣷⣴⣿⠏⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡇⠀⠀⠘⣷⣾⣀⠀⠀⠀⠀⠈⠳⡄⠀⠀⠀
⠀⠀⠀⢸⣤⣀⠀⢀⣴⡾⢏⠀⢀⠏⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠹⡄⠈⣿⣦⡀⠀⠀⣀⡇⠀⠀⠀
⠀⠀⠀⠈⡇⣀⡉⡛⠇⠀⠈⣧⡎⢀⣀⣀⣀⣀⣿⠐⢦⡀⠀⠀⠀⢀⡠⠔⢀⣧⣀⣀⣀⣀⠹⣤⠁⡇⢹⠊⠁⢀⡇⠀⠀⠀
⠀⠀⠀⠀⢹⠀⣀⣡⢸⠀⠀⢻⠀⡏⢫⡹⡿⡙⠻⡝⢲⡽⠂⠀⠀⠁⠰⣯⣿⡟⠉⢉⡽⠉⣧⡿⠀⢰⢸⠋⠉⢹⠁⠀⠀⠀
⠀⠀⠀⠀⠘⡍⠁⠈⢾⣇⠀⢸⡇⢇⠀⠙⠓⢒⣫⡷⠋⠀⠀⠀⠀⠀⠀⠈⢫⣏⠛⠉⠀⢠⢿⡇⠀⣮⡎⠉⠉⣹⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠻⡌⠁⠀⠙⢆⣸⣷⠈⠓⣒⡿⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠛⠶⣖⡉⣸⣃⡼⠟⠉⠉⡩⠋⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠈⢦⠀⠀⠀⠉⠻⢷⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⡼⠛⠁⠀⠀⢀⠞⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠑⣄⠀⠀⠀⠸⡄⠈⠓⢆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠖⠉⢸⠁⠀⠀⠀⣠⠋⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢣⡀⠀⠀⢷⣤⠤⢼⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⠢⣤⣌⠀⠀⢀⡼⠁⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣷⡀⠀⠸⣟⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⡏⠀⢀⣞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣠⢴⣵⠏⠀⣻⣆⠀⣿⣿⠉⡇⠀⢰⣦⢠⡆⢴⡀⢶⠀⢠⣿⣿⣿⠃⢠⣏⠈⠳⡀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣠⣾⡿⢋⡏⠀⣰⠃⠻⣄⢹⡇⠀⢃⠀⣾⢿⡏⣥⣦⣧⠀⣇⢸⠁⠉⡿⢀⡇⠈⢣⠀⢹⣶⣄⠀⠀⠀⠀⠀⠀
⠀⠀⠀⢀⡴⣿⠏⠀⢸⡇⠀⣯⣠⣾⠿⣆⣇⢠⣧⣴⣿⣼⡇⣿⣿⣿⠀⣿⣬⣧⠀⣇⡼⢷⣄⠈⡇⠀⡿⢍⢷⣄⠀⠀⠀⠀
⠀⠀⢀⡞⡼⠁⠀⠀⠸⡇⠀⠸⡟⠁⠀⢹⡼⠘⠁⢸⠸⡏⢹⡿⢿⣿⣾⣿⠀⡇⠀⡿⠃⠀⠻⣿⠃⢠⠇⠀⠳⡙⢦⡀⠀⠀
⠀⠀⡞⢠⠁⠀⠀⠀⠀⢻⡄⠀⠱⣄⡤⠤⢧⠀⠀⢸⢀⣡⣾⣷⢦⣄⡉⣿⠀⡇⣸⠉⠑⠲⣴⠃⢠⡎⠀⠀⠀⠹⡄⢳⡀⠀
⠀⢰⠃⢸⠀⠀⠀⢀⣠⣼⠿⣄⠀⠱⡄⠀⠸⡄⡄⢸⠿⡟⠛⠉⠉⠛⡿⡟⠀⣇⠇⠀⢠⠞⠁⢠⢿⣷⣤⡀⠀⠀⢻⠘⣇⠀
⢀⡇⠀⢸⠀⢀⠖⠋⣿⡏⠀⠙⣦⠀⠙⣦⡀⣇⠸⡶⠀⢿⠀⠀⠀⢰⠃⢷⠎⡟⠀⡰⠋⠀⡰⠋⠀⣿⡌⠻⡆⠀⢸⠀⢻⡀
⢸⠀⠀⠈⢧⠎⠀⠘⣟⢧⣀⠀⠈⠳⣄⠈⠻⣾⡀⢱⠀⠈⡇⣀⣠⡏⢀⠏⣀⡷⠚⢀⡴⠏⠀⢀⣠⢿⠇⠀⢳⣠⠃⠀⠘⡇
⠀⠀⠀⠀⠈⠳⡀⠀⠈⠙⠒⠭⠭⢷⣚⣳⣄⠈⣹⣾⠓⢻⡉⠀⠀⢹⠛⢿⣅⢀⣴⢿⣵⣒⣯⠥⠚⠉⠀⣠⡿⠁⠀⠀⠀⠁
⠀⠀⠀⠀⠀⠀⠈⠒⢤⣀⡀⠀⠀⠀⠀⠈⣹⠟⠉⢹⠀⠈⠳⣄⣠⠞⠀⢸⠏⠻⡉⠉⠁⠀⠀⠀⢀⣤⠞⠋⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⢀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀

⠀⠀⠀⠀⠀⠀⠀⠀
	"
}

# Custom command for ff
function sup {
    fastfetch
}

# Custom function for exiting the terminal
function ggs { exit }

# Custom function for mkdir && cd
function mkcd {
    param([string]$dir)
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    Set-Location $dir
}


# cli code
function ai{ codex }

# copies the pwd
function Copy-Path { (Get-Location).Path | clip }
Set-Alias cpath Copy-Path

# returns immediate children for the dir 
function peek { Get-ChildItem -Force @args }

#runs opencode remotely
function opencode {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Args
    )

    $opencodeCmd = (Get-Command opencode.cmd -CommandType Application -ErrorAction Stop).Source

    if ($Args.Count -gt 0 -and $Args[0] -eq "remote") {
        & $opencodeCmd serve --hostname 0.0.0.0 --port 4096
        return
    }

    & $opencodeCmd @Args
}

#set curl,wget, where as fn 
function curl {
    curl.exe @args
}

function wget {
    wget.exe @args
}

function where {
    where.exe @args
}

#kills all node and bun open ports
function stop-ports {
    Stop-Process -Name node -Force -ErrorAction SilentlyContinue
    Stop-Process -Name bun -Force -ErrorAction SilentlyContinue
}

#better ls
function ll {
    eza --icons --grid --group-directories-first @args
}

#prints img to terminal 
function img {
    wezterm imgcat $args
}

#task manager for terminal 
function check {
    btop
}

#visualise git
function lg {
    lazygit
}
