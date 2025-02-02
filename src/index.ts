/*
    Example code to access a MariaDB using SSL

    npm install mysql2
    npm install @types/node --save-dev
    npm install dotenv
    As admin in powershell
    choco install openssl PEM phrase "test"

 */

import mysql from 'mysql2/promise';
import fs from 'fs';
import path from 'path';
import dotenv from 'dotenv';
    dotenv.config();

const sslPaths = {
    ca_path: process.env.SSL_CA_PATH,
}

const sslOptions = {
    ca: fs.readFileSync(path.resolve(__dirname, sslPaths.ca_path)),
    cert: fs.readFileSync(path.resolve(__dirname, process.env.SSL_CERT_PATH)),
    key: fs.readFileSync(path.resolve(__dirname, process.env.SSL_KEY_PATH)),
    rejectUnauthorized: true    // Reject unauthorized connections
};

const dbConfig = {
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.PASSWORD,
    database: process.env.DB_NAME,
    port: process.env.PORT,
    ssl: sslOptions
};

async function connectToDatabaseSSL() {
    try{
        const connection = await mysql.createConnection(dbConfig);
        console.log("Connected to Database with SSL");
        console.dir(connection);

        //Example SELECT query
        const [rows] = await Promise.all([connection.execute('SELECT VERSION() AS version')]);
        //const [rows] = connection.execute('SELECT VERSION() AS version');

        console.log("Database version:");
        console.dir(rows);

        //Close connection
        await connection.end();
        console.log("Database connection ended");

    } catch (error) {
        console.error(error);
    }
}

console.log('Happy developing ✨')
connectToDatabaseSSL();