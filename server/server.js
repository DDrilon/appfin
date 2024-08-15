const express = require('express');
const { Client } = require('pg');
const app = express();
const port = process.env.PORT || 3000;
const host = process.env.HOST || '127.0.0.1';

app.use(express.json());

// PostgreSQL client configuration
const client = new Client({
  user: process.env.PG_USER || 'postgres',
  host: process.env.PG_HOST || 'localhost',
  database: process.env.PG_DATABASE || 'Drilon',
  password: process.env.PG_PASSWORD || '0108',
  port: process.env.PG_PORT || 5432,
});

// Connect to PostgreSQL
client.connect()
  .then(() => console.log('Connected to PostgreSQL'))
  .catch(err => console.error('Connection error', err.stack));

// API endpoint to fetch messages
app.get('/messages', async (req, res) => {
  try {
    const result = await client.query(`
      SELECT
        m.id_messages AS id,
        u.username_utilisateur AS username,
        m.text_messages AS text,
        m.date_messages AS date,
        a.nom_application AS application_name
      FROM
        messages m
      JOIN
        utilisateur u ON m.id_utilisateur = u.id_utilisateur
      JOIN
        application a ON m.id_application = a.id_application
    `);
    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching messages', err.stack);
    res.status(500).json({ error: 'Error fetching messages' });
  }
});


// API endpoint to fetch users
app.get('/users', async (req, res) => {
  try {
    const result = await client.query(`
      SELECT
        id_utilisateur AS id,
        username_utilisateur AS username,
        date_enregistrement_utilisateur AS date
      FROM
        utilisateur
    `);
    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching users', err.stack);
    res.status(500).json({ error: 'Error fetching users' });
  }
});

// API endpoint to fetch user details and applications
app.get('/user/:id/details', async (req, res) => {
  const userId = req.params.id;

  try {
    // Fetch the user details and their messages
    const userResult = await client.query(`
      SELECT
        u.username_utilisateur AS username,
        m.id_messages AS message_id,
        m.text_messages AS text,
        m.date_messages AS date
      FROM
        utilisateur u
      LEFT JOIN
        messages m ON u.id_utilisateur = m.id_utilisateur
      WHERE u.id_utilisateur = $1
    `, [userId]);

    if (userResult.rows.length === 0) {
      console.log(`User with ID ${userId} does not exist.`);
      return res.status(404).json({ error: 'User not found' });
    }

    const userDetails = {
      username: userResult.rows[0].username,
      messages: userResult.rows.map(row => ({
        id: row.message_id,
        text: row.text,
        date: row.date
      })).filter(message => message.id !== null)
    };

    // Fetch the applications used by the user
    const applicationResult = await client.query(`
      SELECT
        a.nom_application AS name,
        a.description_application AS description
      FROM
        application a
      JOIN
        asso_utilisateur_application aua ON a.id_application = aua.id_application
      WHERE aua.id_utilisateur = $1
    `, [userId]);

    const applications = applicationResult.rows;

    res.json({ userDetails, applications });
  } catch (err) {
    console.error('Error fetching user details', err.stack);
    res.status(500).json({ error: 'Error fetching user details' });
  }
});

// API endpoint to fetch all applications
app.get('/applications', async (req, res) => {
  try {
    const result = await client.query(`
      SELECT
        id_application AS id,
        nom_application AS name,
        description_application AS description
      FROM
        application
    `);
    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching applications', err.stack);
    res.status(500).json({ error: 'Error fetching applications' });
  }
});


// API endpoint to fetch a specific message and its responses
app.get('/messages/:id', async (req, res) => {
  const messageId = req.params.id;
  console.log(`Fetching details for message ID: ${messageId}`);

  try {
    // Fetch the specific message
    const messageResult = await client.query(`
      SELECT
        m.id_messages AS id,
        u.username_utilisateur AS username,
        m.text_messages AS text,
        m.date_messages AS date
      FROM
        messages m
      JOIN
        utilisateur u ON m.id_utilisateur = u.id_utilisateur
      WHERE m.id_messages = $1
    `, [messageId]);

    if (messageResult.rows.length === 0) {
      return res.status(404).json({ error: 'Message not found' });
    }

    // Fetch the responses to the specific message
    const reponsesResult = await client.query(`
      SELECT
        r.id_reponse AS id,
        u.username_utilisateur AS username,
        r.text_reponse AS text,
        r.date_reponse AS date
      FROM
        response r
      JOIN
        utilisateur u ON r.id_utilisateur = u.id_utilisateur
      WHERE r.id_messages = $1
    `, [messageId]);

    const message = messageResult.rows[0];
    const reponses = reponsesResult.rows;

    res.json({ message, reponses });
  } catch (err) {
    console.error('Error fetching message details', err.stack);
    res.status(500).json({ error: 'Error fetching message details' });
  }
});

// API endpoint to fetch responses for a specific message
app.get('/messages/:id/reponses', async (req, res) => {
  const messageId = req.params.id;

  try {
    const reponsesResult = await client.query(`
      SELECT
        r.id_reponse AS id,
        u.username_utilisateur AS username,
        r.text_reponse AS text,
        r.date_reponse AS date
      FROM
        response r
      JOIN
        utilisateur u ON r.id_utilisateur = u.id_utilisateur
      WHERE r.id_messages = $1
    `, [messageId]);

    if (reponsesResult.rows.length === 0) {
      return res.status(404).json({ error: 'No responses found for this message' });
    }

    res.json(reponsesResult.rows);
  } catch (err) {
    console.error('Error fetching responses', err.stack);
    res.status(500).json({ error: 'Error fetching responses' });
  }
});

// API endpoint to fetch messages related to a specific application
app.get('/application/:id/messages', async (req, res) => {
  const appId = req.params.id;

  try {
    const result = await client.query(`
      SELECT
        m.id_messages AS id,
        m.text_messages AS text,
        m.date_messages AS date,
        u.username_utilisateur AS username
      FROM
        messages m
      JOIN
        utilisateur u ON m.id_utilisateur = u.id_utilisateur
      WHERE
        m.id_application = $1
    `, [appId]);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'No messages found for this application' });
    }

    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching messages for application', err.stack);
    res.status(500).json({ error: 'Error fetching messages for application' });
  }
});
// API endpoint to register a new user
app.post('/utilisateur', async (req, res) => {
  const { username, date_enregistrement_utilisateur } = req.body;

  try {
    const result = await client.query(
      'INSERT INTO utilisateur (username_utilisateur, date_enregistrement_utilisateur) VALUES ($1, $2) RETURNING id_utilisateur',
      [username, date_enregistrement_utilisateur]
    );
    res.status(200).json({ id: result.rows[0].id_utilisateur });
  } catch (err) {
    console.error('Error registering user', err.stack);
    res.status(500).json({ error: 'Error registering user' });
  }
});
// Route pour lier une application à un utilisateur
app.post('/user/:id/applications', async (req, res) => {
  const userId = req.params.id;
  const { id_application } = req.body;

  try {
    await client.query(
      'INSERT INTO asso_utilisateur_application (id_utilisateur, id_application) VALUES ($1, $2)',
      [userId, id_application]
    );
    res.status(200).json({ message: 'Application linked successfully' });
  } catch (err) {
    console.error('Error linking application to user', err.stack);
    res.status(500).json({ error: 'Error linking application to user' });
  }
});

app.post('/check-username', async (req, res) => {
  const { username } = req.body;

  try {
    const result = await client.query(
      'SELECT * FROM utilisateur WHERE username_utilisateur = $1',
      [username]
    );

    if (result.rows.length > 0) {
      res.status(409).json({ message: 'Username already exists' });
    } else {
      res.status(200).json({ message: 'Username is available' });
    }
  } catch (err) {
    console.error('Error checking username', err.stack);
    res.status(500).json({ error: 'Error checking username' });
  }
});
app.post('/messages/:id/reponses', async (req, res) => {
  const messageId = req.params.id;
  const { id_utilisateur, text_reponse, date_reponse } = req.body;

  try {
    await client.query(
      'INSERT INTO response (id_utilisateur, id_messages, text_reponse, date_reponse) VALUES ($1, $2, $3, $4)',
      [id_utilisateur, messageId, text_reponse, date_reponse]
    );
    res.status(200).json({ message: 'Response added successfully' });
  } catch (err) {
    console.error('Error adding response', err.stack);
    res.status(500).json({ error: 'Error adding response' });
  }
});
// API endpoint to create a new message
app.post('/messages', async (req, res) => {
  const { id_utilisateur, text_messages, date_messages, id_application } = req.body;

  try {
    const result = await client.query(`
      INSERT INTO messages (id_utilisateur, text_messages, date_messages, id_application)
      VALUES ($1, $2, $3, $4)
      RETURNING id_messages
    `, [id_utilisateur, text_messages, date_messages, id_application]);

    res.json({ id: result.rows[0].id_messages });
  } catch (err) {
    console.error('Error inserting message', err.stack);
    res.status(500).json({ error: 'Error inserting message' });
  }
});


// Start the server
app.listen(port, host, () => {
  console.log(`Server running at http://${host}:${port}`);
});
