if (-NOT (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    Install-Module -Name ExchangeOnlineManagement -Scope CurrentUser
}
Import-Module ExchangeOnlineManagement

$admin = Read-Host "Exchange admin email or UPN"
Connect-ExchangeOnline -UserPrincipalName $admin

#input phishing domains below, separated by commas and quoted (20 domain maximum). E.g. "$domains = 'example.com','example2.com','example3.com', ..."
$domains = 'csatraining.online','csatraining1.online','csatraining2.online','csatraining4.online','csaphishtest1.co.uk','csaphishtest2.co.uk','csalearn.co.uk','gdpreducation.co.uk'
$ipranges = '178.17.44.156','178.17.44.157','178.17.44.158','178.17.44.178','178.17.44.181','45.157.43.226','20.117.205.138'


# Creating Advanced Delivery - Phishing Simulation
New-ExoPhishSimOverrideRule `
    -Policy "PhishSimOverridePolicy" `
    -Domains $domains `
    -SenderIpRanges $ipranges

# Creating Exchange Tranport rule
# Creating CSA Junk Bypass Rule    
New-TransportRule `
    -Name "CSA Junk Bypass" `
    -SenderIpRanges $ipranges `
    -SetSCL -1 `
    -SetHeaderName "X-MS-Exchange-Organization-BypassClutter" `
    -SetheaderValue true `
    -StopRuleProcessing $false `
    -Mode Enforce

# Creating CSA APT Rule    
New-TransportRule `
    -Name "CSA APT Bypass" `
    -SenderIpRanges $ipranges `
    -SetHeaderName "X-MS-Exchange-Organization-SkipSafeLinksProcessing" `
    -SetheaderValue 1 `
    -StopRuleProcessing $true `
    -Mode Enforce
