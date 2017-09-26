function ListMenuItems
{
    cls
    write-host " __          _______ __  __                  ";
    write-host " \ \        / / ____|  \/  |                 ";
    write-host "  \ \  /\  / / |    | \  / | ___ _ __  _   _ ";
    write-host "   \ \/  \/ /| |    | |\/| |/ _ \ '_ \| | | |";
    write-host "    \  /\  / | |____| |  | |  __/ | | | |_| |";
    Write-Host "     \/  \/   \_____|_|  |_|\___|_| |_|\__,_|";
    write-host ""

    For ($i=0; $i -lt $m.Count; $i++) {
        Write-Host $xml.Menuitems.Menuitem[$i].Menunumber $xml.Menuitems.Menuitem[$i].Displayname
    }
    Write-Host "q to quit"
}

function MakeMenuSelection ($inputFromConsole)
{
    For ($i=0; $i -lt $m.Count; $i++) {
        if ($xml.Menuitems.Menuitem[$i].Menunumber -eq $inputFromConsole)
        {
            $commandToRun = $xml.Menuitems.Menuitem[$i].Application + " " + $xml.Menuitems.Menuitem[$i].Arguments
            Write-Host "Command to run: " $commandToRun
            Invoke-Expression $commandToRun
        }
    }
}

$PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent 

$derp = Split-Path $MyInvocation.MyCommand.Path -Parent 
$MenuFile = "menu.xml"
$Path = $derp + "\" + $MenuFile

$xml = New-Object -TypeName XML
$xml.Load($Path)

$m = $xml.Menuitems.Menuitem | measure
#$m.Count

#@($xml.Menuitems.Menuitem).Count
$menuNumber = 0

#assign menu-number to the object, add it as a new property
For ($i=0; $i -lt $m.Count; $i++) {
    Add-Member -InputObject $xml.Menuitems.Menuitem[$i] -MemberType NoteProperty `
        -Name Menunumber -Value $i
        $menuNumber += 1
}

do
{
    ListMenuItems
    $input = Read-Host "Please make a selection"
    MakeMenuSelection $input
}
until ($input -eq 'q')