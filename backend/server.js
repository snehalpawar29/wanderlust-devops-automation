import compression from 'compression';
import cookieParser from 'cookie-parser';
import cors from 'cors';
import express from 'express';
import connectDB from './config/db.js';
import { PORT } from './config/utils.js';
import authRouter from './routes/auth.js';
import postsRouter from './routes/posts.js';
import mongoose from 'mongoose';
import { connectToRedis } from './services/redis.js';
const app = express();
const port = PORT || 5000;

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors());
app.use(cookieParser());
app.use(compression());

// Connect to database
connectDB();

// Connect to redis
connectToRedis();

// API route
app.use('/api/posts', postsRouter);
app.use('/api/auth', authRouter);

app.get('/health/live', (_req, res) => {
  res.status(200).json({
    status: 'alive',
  });
});

// Kubernetes readiness check.
// The application is ready only when MongoDB is connected.
app.get('/health/ready', (_req, res) => {
  const databaseReady = mongoose.connection.readyState === 1;

  if (!databaseReady) {
    return res.status(503).json({
      status: 'not_ready',
      mongodb: 'disconnected',
    });
  }

  return res.status(200).json({
    status: 'ready',
    mongodb: 'connected',
  });
});

app.get('/', (req, res) => {
  res.send('Yay!! Backend of wanderlust prod app is now accessible');
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});

export default app;
