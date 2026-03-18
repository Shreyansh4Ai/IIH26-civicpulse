# CivicPulse 🏛️

> **Hackathon Project — IIH26**
>
> Empowering citizens to engage, report, and connect with their communities.

---

## 📖 Table of Contents

- [About the Project](#about-the-project)
- [Problem Statement](#problem-statement)
- [Key Features](#key-features)
- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Running the App](#running-the-app)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Screenshots](#screenshots)
- [Team](#team)
- [Contributing](#contributing)
- [License](#license)

---

## 🌟 About the Project

**CivicPulse** is a community-driven civic engagement platform designed to bridge the gap between citizens and local governance. The platform allows residents to report local issues (potholes, street lighting, water supply problems, etc.), track the resolution status, vote on community priorities, and stay informed about civic decisions in their neighborhood — all in one place.

---

## ❓ Problem Statement

Citizens often lack a simple, transparent channel to:
- Report civic issues to the right authorities.
- Track whether their complaints are being addressed.
- Participate in community decision-making.
- Access reliable, real-time information about local governance.

CivicPulse solves this by providing a unified digital platform that connects citizens, local government bodies, and community volunteers.

---

## ✨ Key Features

| Feature | Description |
|---|---|
| 📍 Issue Reporting | Report civic problems with location, photos, and category tags |
| 🗳️ Community Voting | Upvote issues to help prioritize the most pressing concerns |
| 📊 Live Dashboard | Real-time status tracking for reported issues |
| 🔔 Notifications | Get updates when your reported issue is acknowledged or resolved |
| 🗺️ Interactive Map | Visualize all reported issues on an area map |
| 👥 Community Forums | Discuss and collaborate on local civic topics |
| 🏅 Gamification | Earn badges and recognition for active civic participation |
| 🔐 Secure Auth | User authentication with role-based access (Citizen / Official / Admin) |

---

## 🛠️ Tech Stack

### Frontend
- **React.js** — Component-based UI
- **Tailwind CSS** — Utility-first styling
- **Leaflet.js** — Interactive maps

### Backend
- **Node.js + Express.js** — REST API server
- **MongoDB** — NoSQL database for flexible data storage
- **Mongoose** — ODM for MongoDB

### Authentication & Services
- **JWT** — Secure token-based authentication
- **Cloudinary** — Image upload and storage
- **Socket.io** — Real-time notifications

### DevOps & Tooling
- **Git & GitHub** — Version control
- **Docker** — Containerized deployment
- **Render / Vercel** — Cloud hosting

---

## 🚀 Getting Started

### Prerequisites

Make sure you have the following installed on your machine:

- [Node.js](https://nodejs.org/) (v18+)
- [npm](https://www.npmjs.com/) or [yarn](https://yarnpkg.com/)
- [MongoDB](https://www.mongodb.com/) (local or Atlas cloud)
- [Git](https://git-scm.com/)

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/Shreyansh4Ai/IIH26-civicpulse.git
   cd IIH26-civicpulse
   ```

2. **Install backend dependencies**

   ```bash
   cd backend
   npm install
   ```

3. **Install frontend dependencies**

   ```bash
   cd ../frontend
   npm install
   ```

4. **Set up environment variables**

   Create a `.env` file in the `backend/` directory and add:

   ```env
   PORT=5000
   MONGO_URI=your_mongodb_connection_string
   JWT_SECRET=your_jwt_secret_key
   CLOUDINARY_CLOUD_NAME=your_cloudinary_cloud_name
   CLOUDINARY_API_KEY=your_cloudinary_api_key
   CLOUDINARY_API_SECRET=your_cloudinary_api_secret
   ```

   Create a `.env` file in the `frontend/` directory and add:

   ```env
   REACT_APP_API_URL=http://localhost:5000/api
   ```

### Running the App

1. **Start the backend server**

   ```bash
   cd backend
   npm run dev
   ```

2. **Start the frontend development server**

   ```bash
   cd frontend
   npm start
   ```

3. Open your browser and navigate to `http://localhost:3000`

---

## 📋 Usage

1. **Sign up / Log in** — Create a citizen account or log in with existing credentials.
2. **Report an Issue** — Click "Report Issue", fill in the details, attach a photo, and pin the location on the map.
3. **Track Progress** — Monitor the status of your reported issues from your dashboard.
4. **Vote on Issues** — Browse community-reported issues and upvote the ones that matter most.
5. **Join Discussions** — Participate in community forums to discuss civic topics.
6. **Officials Portal** — Government officials can log in to view, assign, and update the status of reported issues.

---

## 📁 Project Structure

```
IIH26-civicpulse/
├── frontend/
│   ├── public/
│   ├── src/
│   │   ├── components/
│   │   ├── pages/
│   │   ├── context/
│   │   ├── hooks/
│   │   ├── utils/
│   │   └── App.js
│   └── package.json
├── backend/
│   ├── controllers/
│   ├── models/
│   ├── routes/
│   ├── middleware/
│   ├── config/
│   └── server.js
├── .gitignore
└── README.md
```

---

## 📸 Screenshots

> _Screenshots and demo GIFs will be added as the project progresses._

---

## 👥 Team

| Name | Role | GitHub |
|---|---|---|
| Shreyansh | Team Lead / Full Stack | [@Shreyansh4Ai](https://github.com/Shreyansh4Ai) |

> _We are Team IIH26 — Champions Here! 🏆_

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a new branch: `git checkout -b feature/your-feature-name`
3. Make your changes and commit: `git commit -m "Add: your feature description"`
4. Push to the branch: `git push origin feature/your-feature-name`
5. Open a Pull Request

Please make sure your code follows the existing style and all tests pass before submitting.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

<div align="center">
  <strong>Built with ❤️ for better communities — Team IIH26</strong>
</div>
