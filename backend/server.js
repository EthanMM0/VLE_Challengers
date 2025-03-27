// ./backend/server.js

const express = require('express');
const mongoose = require('mongoose');
const axios = require('axios');
const cors = require('cors');
const fetch = require('node-fetch'); // Import node-fetch for fetching rank data
require('dotenv').config(); // Load environment variables from .env
const bcrypt = require('bcrypt'); // Import bcrypt

const User = require('./models/User'); // Use `require` for CommonJS
const ValUserData = require('./models/ValUserData'); // Use `require` for CommonJS

const app = express();
const port = 5000;

app.use(cors());
app.use(express.json()); // Ensure request body is parsed

// MongoDB Connection
const mongoURI = process.env.MONGO_URI;

mongoose.connect(mongoURI, {})
  .then(() => console.log('MongoDB connected'))
  .catch((err) => {
    console.error('MongoDB connection error:', err);
    process.exit(1); // Exit if MongoDB connection fails
  });

// Helper to log incoming requests
app.use((req, res, next) => {
  console.log('Incoming Request:', req.method, req.url, req.body);
  next();
});

// Fetch Riot Account Data
async function fetchAccountData(valorantUsername, tagline) {
  try {
    const response = await axios.get(
      `https://americas.api.riotgames.com/riot/account/v1/accounts/by-riot-id/${valorantUsername}/${tagline}`,
      {
        headers: {
          'X-Riot-Token': process.env.RIOT_API_KEY,
        },
      }
    );

    return {
      gameName: response.data.gameName,
      tagLine: response.data.tagLine,
    };
  } catch (err) {
    console.error('Error fetching account data:', err.message);
    throw new Error('Invalid Riot credentials');
  }
}

// Fetch Rank Data from HenrikDev API (using GET)
async function fetchRankData(gameName, tagLine) {
  try {
    const cleanedTagLine = tagLine.replace('#', '');
    console.log(`Fetching rank for: ${gameName}#${cleanedTagLine}`);

    const apiKey = process.env.HENRIKDEV_API_KEY;
    const url = `https://api.henrikdev.xyz/valorant/v2/mmr/na/${gameName}/${cleanedTagLine}`;

    const headers = {
      Authorization: apiKey,
    };

    const response = await fetch(url, { headers });

    if (!response.ok) {
      console.error(`Failed to fetch rank data. Status: ${response.status}`);
      throw new Error('Failed to fetch rank data');
    }

    const data = await response.json();
    console.log('HenrikDev API Response:', data);

    const curRank = data.data.current_data.currenttierpatched || 'Unranked';
    return curRank;
  } catch (err) {
    console.error('Error fetching rank data:', err.message);
    return 'Unranked';
  }
}

// Link Valorant Account with GET Request
app.get('/link-valorant', async (req, res) => {
  const { username, valorantUsername, tagline } = req.query;

  if (!valorantUsername || !tagline) {
    return res.status(400).json({ error: 'Valorant Username or Tagline is missing' });
  }

  try {
    const accountData = await fetchAccountData(valorantUsername, tagline);
    const curRank = await fetchRankData(accountData.gameName, accountData.tagLine);

    // Update the user's document in the User collection
    const updatedUser = await User.findOneAndUpdate(
      { username },
      {
        valorantUsername: accountData.gameName,
        valorantTag: accountData.tagLine,
        valorantRank: curRank,
      },
      { new: true } // Return the updated document
    );

    if (!updatedUser) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.status(200).json({
      message: 'Valorant account linked successfully',
      valorantUsername: updatedUser.valorantUsername,
      valorantTag: updatedUser.valorantTag,
      valorantRank: updatedUser.valorantRank,
    });
  } catch (err) {
    console.error('Error linking account:', err.message);
    res.status(500).json({ error: err.message });
  }
});


// User Registration Route
app.post('/register', async (req, res) => {
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(400).json({ error: 'Username and password are required' });
  }

  try {
    const existingUser = await User.findOne({ username });
    if (existingUser) {
      return res.status(400).json({ error: 'Username already taken' });
    }

    // Create new user without Valorant account linking fields
    const newUser = new User({
      username,
      password, // Store the hashed password
    });

    await newUser.save();
    res.status(201).json({ message: 'Account created! Please log in.' });
  } catch (err) {
    console.error('Error registering user:', err.message);
    res.status(500).json({ error: 'Server error during registration' });
  }
});

// Login Route
app.post('/login', async (req, res) => {
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(400).json({ error: 'Username and password are required' });
  }

  try {
    const user = await User.findOne({ username });
    if (!user) {
      return res.status(400).json({ error: 'Invalid username or password' });
    }

    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return res.status(400).json({ error: 'Invalid username or password' });
    }

    // Include Valorant account data in the response
    const { password: _, ...userData } = user.toObject();
    res.status(200).json(userData);
  } catch (err) {
    console.error('Error logging in user:', err.message);
    res.status(500).json({ error: 'Server error during login' });
  }
});




// Start Server
app.listen(port, '0.0.0.0', () => console.log(`Server running at ${port}`));
