#!/bin/bash
# Demyx
# https://demyx.sh
set -euo pipefail

OPENLITESPEED_DOMAIN="${OPENLITESPEED_DOMAIN:-domain.tld}"

# httpd_config.conf
echo "# Demyx
# https://demyx.sh

serverName                              Demyx
user                                    nobody
group                                   nogroup
priority                                0
autoRestart                             1 
chrootPath                              /
enableChroot                            0 
inMemBufSize                            60M 
swappingDir                             /tmp/lshttpd/swap 
autoFix503                              1 
gracefulRestartTimeout                  300
mime                                    conf/mime.properties 
useIpInProxyHeader                      1
showVersionNumber                       0 
adminEmails                             demyx@localhost
indexFiles                              index.html, index.php
disableWebAdmin                         0

errorlog ${OPENLITESPEED_LOG}/ols.error.log {
    logLevel                            DEBUG
    debugLevel                          0
    rollingSize                         10M
    enableStderrLog                     1
}
    
accessLog ${OPENLITESPEED_LOG}/ols.access.log {
    rollingSize                         10M    
    keepDays                            30    
    compressArchive                     0
    logReferer                          1     
    logUserAgent                        1
}
    
expires {
    enableExpires                       1
    expiresByType                       image/*=A604800,text/css=A604800,application/x-javascript=A604800,application/javascript=A604800,font/*=A604800,application/x-font-ttf=A604800
}

tuning{
    maxConnections                      $OPENLITESPEED_TUNING_MAX_CONNECTIONS
    maxSSLConnections                   $OPENLITESPEED_TUNING_MAX_CONNECTIONS
    connTimeout                         $OPENLITESPEED_TUNING_CONNECTION_TIMEOUT
    maxKeepAliveReq                     $OPENLITESPEED_TUNING_MAX_KEEP_ALIVE
    smartKeepAlive                      $OPENLITESPEED_TUNING_SMART_KEEP_ALIVE
    keepAliveTimeout                    $OPENLITESPEED_TUNING_KEEP_ALIVE_TIMEOUT
    sndBufSize                          0 
    rcvBufSize                          0 
    gzipStaticCompressLevel             6 
    gzipMaxFileSize                     10M 
    eventDispatcher                     best 
    maxCachedFileSize                   4096 
    totalInMemCacheSize                 20M 
    maxMMapFileSize                     256K 
    totalMMapCacheSize                  40M 
    useSendfile                         1 
    fileETag                            28 
    SSLCryptoDevice                     null 
    maxReqURLLen                        32768 
    maxReqHeaderSize                    65536 
    maxReqBodySize                      2047M 
    maxDynRespHeaderSize                32768 
    maxDynRespSize                      2047M 
    enableGzipCompress                  1
    enableBrCompress                    4
    enableDynGzipCompress               1 
    gzipCompressLevel                   6 
    brStaticCompressLevel               6
    compressibleTypes                   text/*, application/x-javascript, application/xml, application/javascript, image/svg+xml,application/rss+xml
    gzipAutoUpdateStatic                1 
    gzipMinFileSize                     300 
    quicEnable                          1
    quicShmDir                          /dev/shm
}

accessDenyDir {
    dir                                 /
    dir                                 /etc/*
    dir                                 /dev/*
    dir                                 conf/*
    dir                                 admin/conf/*
}

fileAccessControl {
    followSymbolLink                    1 
    checkSymbolLink                     0 
    requiredPermissionMask              000 
    restrictedPermissionMask            000 
}

perClientConnLimit {
    staticReqPerSec                     $OPENLITESPEED_CLIENT_THROTTLE_STATIC
    dynReqPerSec                        $OPENLITESPEED_CLIENT_THROTTLE_DYNAMIC
    outBandwidth                        $OPENLITESPEED_CLIENT_THROTTLE_BANDWIDTH_OUT
    inBandwidth                         $OPENLITESPEED_CLIENT_THROTTLE_BANDWIDTH_IN
    softLimit                           $OPENLITESPEED_CLIENT_THROTTLE_SOFT_LIMIT
    hardLimit                           $OPENLITESPEED_CLIENT_THROTTLE_HARD_LIMIT
    blockBadReq                         $OPENLITESPEED_CLIENT_THROTTLE_BLOCK_BAD_REQUEST
    gracePeriod                         $OPENLITESPEED_CLIENT_THROTTLE_GRACE_PERIOD
    banPeriod                           $OPENLITESPEED_CLIENT_THROTTLE_BAN_PERIOD
}

lsrecaptcha  {
    enabled                             $OPENLITESPEED_RECAPTCHA_ENABLE
    type                                $OPENLITESPEED_RECAPTCHA_TYPE
    regConnLimit                        $OPENLITESPEED_RECAPTCHA_CONNECTION_LIMIT
    sslConnLimit                        $OPENLITESPEED_RECAPTCHA_CONNECTION_LIMIT
}

CGIRLimit {
    maxCGIInstances                     20 
    minUID                              11 
    minGID                              10 
    priority                            0 
    CPUSoftLimit                        10 
    CPUHardLimit                        50 
    memSoftLimit                        1460M
    memHardLimit                        1470M
    procSoftLimit                       400 
    procHardLimit                       450 
}
    
accessControl {
    allow                               ALL
    deny
}
 
extProcessor lsphp {
    type                                lsapi 
    address                             uds://tmp/lshttpd/lsphp.sock 
    maxConns                            10 
    env                                 PHP_LSAPI_CHILDREN=$OPENLITESPEED_PHP_LSAPI_CHILDREN
    env                                 LSAPI_AVOID_FORK=200M
    initTimeout                         60 
    retryTimeout                        0 
    persistConn                         1 
    pcKeepAliveTimeout                  60
    respBuffer                          0 
    autoStart                           1 
    path                                fcgi-bin/lsphp
    backlog                             100 
    instances                           1 
    priority                            0 
    memSoftLimit                        2047M
    memHardLimit                        2047M
    procSoftLimit                       1400 
    procHardLimit                       1500 
}

scriptHandler {
    add lsapi:lsphp                     php
}

railsDefaults {
    binPath                  
    railsEnv                            1 
    maxConns                            1 
    env                                 LSAPI_MAX_IDLE=60 
    initTimeout                         60 
    retryTimeout                        0 
    pcKeepAliveTimeout                  60 
    respBuffer                          0 
    backlog                             50 
    runOnStartUp                        3
    extMaxIdleTime                      300
    priority                            3 
    memSoftLimit                        2047M 
    memHardLimit                        2047M 
    procSoftLimit                       500 
    procHardLimit                       600 
}

wsgiDefaults {
    binPath                  
    railsEnv                            1 
    maxConns                            5 
    env                                 LSAPI_MAX_IDLE=60 
    initTimeout                         60 
    retryTimeout                        0 
    pcKeepAliveTimeout                  60 
    respBuffer                          0 
    backlog                             50 
    runOnStartUp                        3
    extMaxIdleTime                      300
    priority                            3 
    memSoftLimit                        2047M 
    memHardLimit                        2047M 
    procSoftLimit                       500 
    procHardLimit                       600 
}

nodeDefaults{
    binPath                  
    railsEnv                            1 
    maxConns                            5 
    env                                 LSAPI_MAX_IDLE=60 
    initTimeout                         60 
    retryTimeout                        0 
    pcKeepAliveTimeout                  60 
    respBuffer                          0 
    backlog                             50 
    runOnStartUp                        3
    extMaxIdleTime                      300
    priority                            3 
    memSoftLimit                        2047M 
    memHardLimit                        2047M 
    procSoftLimit                       500 
    procHardLimit                       600 
}

virtualHost $OPENLITESPEED_DOMAIN {
    vhRoot                              $OPENLITESPEED_CONFIG/ols
    allowSymbolLink                     1 
    enableScript                        1 
    restrained                          1 
    setUIDMode                          0
    user                                demyx
    group                               demyx
    chrootMode                          0 
    configFile                          conf/vhosts/ols/vhconf.conf
}

listener Default {
    address                             *:80
    secure                              0
    map                                 $OPENLITESPEED_DOMAIN *
}
    
vhTemplate centralConfigLog {
    templateFile                        conf/templates/ccl.conf
    listeners                           Default
}

vhTemplate EasyRailsWithSuEXEC {
    templateFile                        conf/templates/rails.conf
    listeners                           Default
}

module cache {
    ls_enabled                          1
    checkPrivateCache                   1
    checkPublicCache                    1
    maxCacheObjSize                     10000000
    maxStaleAge                         200
    qsCache                             1
    reqCookieCache                      1
    respCookieCache                     1
    ignoreReqCacheCtrl                  1
    ignoreRespCacheCtrl                 0
    enableCache                         0
    expireInSeconds                     3600
    enablePrivateCache                  0
    privateExpireInSeconds              3600

}

" > "$OPENLITESPEED_CONFIG"/ols/httpd_config.conf

# vhconf.conf

# Enable opcache by default
if [[ "${OPENLITESPEED_PHP_OPCACHE}" = false ]]; then
    OPENLITESPEED_PHP_OPCACHE="php_admin_value opcache.enable 0"
else
    OPENLITESPEED_PHP_OPCACHE=
fi

# Update auto_prepend_file if WordFence exists
if [[ -d "$OPENLITESPEED_ROOT"/wp-content/plugins/wordfence ]]; then
    OPENLITESPEED_WORDFENCE="php_value auto_prepend_file ${OPENLITESPEED_ROOT}/wordfence-waf.php"
else
    OPENLITESPEED_WORDFENCE=
fi

# Disable xmlrpc.php by default
if [[ "$OPENLITESPEED_XMLRPC" = false ]]; then
    OPENLITESPEED_XMLRPC="RewriteRule ^xmlrpc.php - [F,L]"
else
    OPENLITESPEED_XMLRPC=
fi

echo "# Demyx
# https://demyx.sh

docRoot                                 /demyx
enableGzip                              1
cgroups                                 0

errorlog ${OPENLITESPEED_LOG}/${OPENLITESPEED_DOMAIN}.error.log {
    useServer                           0
    logLevel                            DEBUG
    rollingSize                         10M
}

accesslog ${OPENLITESPEED_LOG}/${OPENLITESPEED_DOMAIN}.access.log {
    useServer                           0
    logHeaders                          7
    rollingSize                         10M
    keepDays                            30
    compressArchive                     0
}

index {
    useServer                           1
    indexFiles                          index.html, index.php
    autoIndex                           0
}

accessControl  {
    allow                               ALL
}

context / {
    allowBrowse                         1
    extraHeaders                        <<<END_extraHeaders
        Access-Control-Allow-Origin *
        Feature-Policy \"geolocation 'self'; midi 'self'; sync-xhr 'self'; microphone 'self'; camera 'self'; magnetometer 'self'; gyroscope 'self'; speaker 'self'; fullscreen 'self'; payment 'self'; usb 'self'\"
        Referrer-Policy strict-origin-when-cross-origin
        Strict-Transport-Security max-age=31536000; preload; includeSubDomains; always
        X-Content-Type-Options nosniff; always
        X-Download-Options noopen
        X-Frame-Options SAMEORIGIN
        X-Powered-By Demyx
        X-XSS-Protection 1; mode=block
    END_extraHeaders

    rewrite {
        enable                         1
        autoLoadHtaccess               1
        rules                               <<<END_rules
            AddDefaultCharset UTF-8

            # BEGIN WordPress
            RewriteEngine On
            RewriteBase /
            RewriteRule ^/index.php$ - [L]
            RewriteCond %{REQUEST_FILENAME} !-f
            RewriteCond %{REQUEST_FILENAME} !-d
            RewriteRule . /index.php [L]
            # END WordPress

            # Block null user agent
            <IfModule LiteSpeed>
                RewriteEngine On
                RewriteCond %{HTTP_USER_AGENT} ^-$
                RewriteRule ^ - [F]
            </IfModule>

            # Block these user agents
            <IfModule LiteSpeed>
                RewriteEngine On
                RewriteCond %{HTTP_USER_AGENT} ^.*(?:acunetix|BLEXBot|domaincrawler\.com|LinkpadBot|MJ12bot/v|majestic12\.co\.uk|AhrefsBot|TwengaBot|SemrushBot|nikto|winhttp|Xenu\s+Link\s+Sleuth|Baiduspider|HTTrack|clshttp|harvest|extract|grab|miner|python-requests).*$ [NC]
                RewriteRule .* - [F,L]
            </IfModule>

            # 403
            <IfModule LiteSpeed>
                RewriteEngine On
                RewriteBase /

                # Block hidden files/directories
                RewriteRule (^\.) - [F,L]

                # Return 403 forbidden for readme.(txt|html) or license.(txt|html) or example.(txt|html) or other common git repository files
                RewriteRule \.(txt|html|md)$ - [F,L]
                RewriteRule ^(readme|license|example|changelog|README|LEGALNOTICE|INSTALLATION|CHANGELOG|html|md)$ - [F,L]

                # Deny backup extensions & log files and return 403 forbidden
                RewriteRule \.(old|orig|original|php#|php~|php_bak|save|swo|aspx?|tpl|sh|bash|bak?|cfg|cgi|dll|exe|git|hg|ini|jsp|log|mdb|out|sql|svn|swp|tar|rdf)$ - [F,L]

                # Disable XMLRPC
                $OPENLITESPEED_XMLRPC

                # Block php in wp-content/uploads
                RewriteRule ^wp-content/uploads/[^/]+\.php$ - [F,L]

                # Misc
                RewriteRule (&pws=0|_vti_|\(null\)|\{\$itemURL\}|echo(.*)kae|boot\.ini|etc/passwd|eval\(|self/environ|cgi-|muieblack) - [F,L]
                RewriteRule ^/wp-admin/load-|(script|style).php - [F,L]
                RewriteRule \.(psd|cmd|bat|csh)$ - [F,L]
            </IfModule>

            # Disable modifications to wp-admin / wp-includes folders
            <IfModule LiteSpeed>
                RewriteEngine On
                RewriteBase /
                RewriteRule ^wp-admin/includes/ - [F,L]
                RewriteRule !^wp-includes/ - [S=3]
                RewriteRule ^wp-includes/[^/]+\.php$ - [F,L]
                RewriteRule ^wp-includes/js/tinymce/langs/.+\.php - [F,L]
                RewriteRule ^wp-includes/theme-compat/ - [F,L]
                RewriteRule ^wp-includes/[^/]+\.xml$ - [F,L]
            </IfModule>

            # Prevent username enumeration
            RewriteCond %{QUERY_STRING} author=d
            RewriteRule ^ /? [L,R=301]

            # Prevent script injection
            <IfModule LiteSpeed>
                Options +FollowSymLinks
                RewriteEngine On
                RewriteCond %{QUERY_STRING} (<|%3C).*script.*(>|%3E) [NC,OR]
                RewriteCond %{QUERY_STRING} GLOBALS(=|[|%[0-9A-Z]{0,2}) [OR]
                RewriteCond %{QUERY_STRING} _REQUEST(=|[|%[0-9A-Z]{0,2})
                RewriteRule ^(.*)$ index.php [F,L]
            </IfModule>

            # Blocks some XSS attacks
            <IfModule LiteSpeed>
                RewriteCond %{QUERY_STRING} (\|%3E) [NC,OR]
                RewriteCond %{QUERY_STRING} GLOBALS(=|\[|\%[0-9A-Z]{0,2}) [OR]
                RewriteCond %{QUERY_STRING} _REQUEST(=|\[|\%[0-9A-Z]{0,2})
                RewriteRule .* index.php [F,L]
            </IfModule>
        END_rules
    }
}

rewrite {
    enable                              1
    autoLoadHtaccess                    1
}

phpIniOverride  {
    php_admin_value date.timezone       $TZ
    php_admin_value max_execution_time  $OPENLITESPEED_PHP_MAX_EXECUTION_TIME
    php_admin_value memory_limit        $OPENLITESPEED_PHP_MEMORY
    $OPENLITESPEED_PHP_OPCACHE
    php_admin_value post_max_size       $OPENLITESPEED_PHP_UPLOAD_LIMIT
    php_admin_value upload_max_filesize $OPENLITESPEED_PHP_UPLOAD_LIMIT
    $OPENLITESPEED_WORDFENCE
}

module cache {
    checkPrivateCache                   1
    checkPublicCache                    1
    maxCacheObjSize                     10000000
    maxStaleAge                         200
    qsCache                             1
    reqCookieCache                      1
    respCookieCache                     1
    ignoreReqCacheCtrl                  1
    ignoreRespCacheCtrl                 0

    enableCache                         0
    expireInSeconds                     3600
    enablePrivateCache                  0
    privateExpireInSeconds              3600
    ls_enabled                          1
}

" > "$OPENLITESPEED_CONFIG"/ols/vhconf.conf

# admin_config.conf

# Lockdown admin url if OPENLITESPEED_ADMIN_IP value changed
if [[ "$OPENLITESPEED_ADMIN_IP" != ALL ]]; then
    OPENLITESPEED_ADMIN_IP_DENY=ALL
fi

echo "# Demyx
# https://demyx.sh

enableCoreDump                          1
sessionTimeout                          3600

errorlog ${OPENLITESPEED_LOG}/ols.error.log {
  useServer                             1
  logLevel                              INFO
  rollingSize                           10M
}

accessLog ${OPENLITESPEED_LOG}/ols.access.log {
  useServer                             1
  rollingSize                           10M
  keepDays                              90
  logReferer                            1
  logUserAgent                          1
}

accessControl {
  allow                                 $OPENLITESPEED_ADMIN_IP
  deny                                  ${OPENLITESPEED_ADMIN_IP_DENY:-}
}

listener adminListener{
  address                               *:8080
  secure                                0
}
" > "$OPENLITESPEED_CONFIG"/ols/admin_config.conf

# Set proper ownership so lsws can write to the configs
chown -R lsadm:lsadm "$OPENLITESPEED_CONFIG"/ols
