import { createClient } from 'redis';
import { REDIS_URL } from '../config/utils.js';

let redis = null;

export async function connectToRedis() {
  const maxRetries = 10;
  let attempts = 0;

  while (attempts < maxRetries) {
    try {
      if (REDIS_URL) {
        redis = await createClient({
          url: REDIS_URL,
          disableOfflineQueue: true,
          socket: {
            reconnectStrategy: (retries) => Math.min(retries * 50, 1000) // Auto-reconnect on disconnect
          }
        }).connect();
        console.log('Redis Connected: ' + REDIS_URL);
        return; // Success, exit retry loop
      } else {
        console.log('Redis not configured, cache disabled.');
        return;
      }
    } catch (error) {
      attempts++;
      console.error(`Attempt ${attempts}/${maxRetries} failed: Error connecting to Redis:`, error.message);
      if (attempts >= maxRetries) throw error;
      await new Promise(res => setTimeout(res, 3000)); // Wait 3 seconds before trying again
    }
  }
}

export function getRedisClient() {
  return redis;
}
