/*
    Example code to access a MariaDB using SSL

    npm install mysql2
    npm install @types/node --save-dev
    npm install dotenv
    As admin in powershell
    choco install openssl PEM phrase "test"

 */

import mysql from 'mariadb';
import fs from 'fs';
import path from 'path';
import dotenv from 'dotenv';
    dotenv.config();


const sslOptions = {
    //Path are relative to this file directory
    ca: fs.readFileSync(path.resolve( __dirname + "/../ssl/" + "ca-cert.pem"), 'utf8'),
    cert: fs.readFileSync(path.resolve(__dirname + "/../ssl/"  + "client-cert.pem"), 'utf8'),
    key: fs.readFileSync(path.resolve(__dirname + "/../ssl/" + "client-key.pem"), 'utf8'),
    rejectUnauthorized: true    // Reject unauthorized connections
};

const dbConfig = {
    host: "127.0.0.1",
    user: "test",
    password: "test",
    database: "test",
    port: "3306",
    ssl: sslOptions
};

const sleep = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

async function connectToDatabaseSSL() {
    try{

        let connection = await mysql.createConnection(
            {
                host: "127.0.0.1",
                user: "root",
                password: "",
                database: "",

            } )
        console.log("Connected to Database with SSL");

        //Example SELECT query
        const [rows] = await connection.execute('SELECT VERSION() AS version');
        //const [rows] = connection.execute('SELECT VERSION() AS version');

        console.log("Database version:");
        console.dir(rows);

        //Close connection
        await sleep(10000);
        await connection.end();
        console.log("Database connection ended");

    } catch (error) {
        console.error("Database connection failed");
        console.error(error);
    }
}

console.log('Happy developing ✨');
connectToDatabaseSSL();