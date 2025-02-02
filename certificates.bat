@echo off
REM Script to generate SSL certificates valid for 3 years

REM Variables
set DAYS=1095
set CA_KEY=ca-key.pem
set CA_CERT=ca-cert.pem
set SERVER_KEY=server-key.pem
set SERVER_CERT=server-cert.pem
set CLIENT_KEY=client-key.pem
set CLIENT_CERT=client-cert.pem

REM Create CA private key
openssl genpkey -algorithm RSA -out %CA_KEY% -aes256
if %errorlevel% neq 0 (
    echo Failed to generate CA private key.
    exit /b 1
)

REM Create CA certificate
openssl req -new -x509 -days %DAYS% -key %CA_KEY% -out %CA_CERT%
if %errorlevel% neq 0 (
    echo Failed to create CA certificate.
    exit /b 1
)

REM Create server private key
openssl genpkey -algorithm RSA -out %SERVER_KEY%
if %errorlevel% neq 0 (
    echo Failed to generate server private key.
    exit /b 1
)

REM Create server CSR
openssl req -new -key %SERVER_KEY% -out server-req.pem
if %errorlevel% neq 0 (
    echo Failed to create server CSR.
    exit /b 1
)

REM Sign server certificate
openssl x509 -req -in server-req.pem -days %DAYS% -CA %CA_CERT% -CAkey %CA_KEY% -CAcreateserial -out %SERVER_CERT%
if %errorlevel% neq 0 (
    echo Failed to sign server certificate.
    exit /b 1
)

REM Create client private key
openssl genpkey -algorithm RSA -out %CLIENT_KEY%
if %errorlevel% neq 0 (
    echo Failed to generate client private key.
    exit /b 1
)

REM Create client CSR
openssl req -new -key %CLIENT_KEY% -out client-req.pem
if %errorlevel% neq 0 (
    echo Failed to create client CSR.
    exit /b 1
)

REM Sign client certificate
openssl x509 -req -in client-req.pem -days %DAYS% -CA %CA_CERT% -CAkey %CA_KEY% -CAcreateserial -out %CLIENT_CERT%
if %errorlevel% neq 0 (
    echo Failed to sign client certificate.
    exit /b 1
)

REM Clean up temporary files
del server-req.pem
del client-req.pem

echo Certificates generated successfully.
pause