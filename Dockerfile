# Use the official Node.js image as the base image
FROM node:18-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy the package.json and package-lock.json files
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Next.js application
RUN npm run build

# Use a lightweight Node.js image for production
FROM node:18-alpine AS runner

# Set the working directory
WORKDIR /app

# Copy the node_modules and build output from the builder stage
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./

# Expose the port the app runs on
EXPOSE 3000

# Start the Next.js server
CMD ["npm", "start"]
