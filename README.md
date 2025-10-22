Project Charlie Main
=====================

Overview
--------

Project_Charlie_Main is a multi-part application that includes:

- A React frontend (located in `frontend/`), with a built production bundle in `frontend/build/` and the React source in `frontend/src/` and `frontend/client/`.
- A Python-based backend/server in `Server/` that provides endpoints and static files.
- An NLP microservice in `NLP/` (Flask app) for natural language processing tasks.

This README explains how to install, run, and troubleshoot each component.

Prerequisites
-------------

- Node.js (>= 14) and npm or yarn
- Python 3.8+ and pip
- (Optional) Docker if you prefer containerized runs
- Git (to clone repository)

Repository layout
-----------------

Top-level:

- `frontend/` — React app and built production bundle
  - `frontend/client/` — React project used for development
  - `frontend/build/` — production build artifacts (served by the backend in some setups)
  - `frontend/src/` — React source files
- `Server/` — Python-based server and static site
- `NLP/` — Flask-based NLP microservice
- `main.py` — (project-level entry or demo orchestrator)
- `uploads/`, `static/`, `User/`, `validation/` — data and storage folders used by server

Installation
------------

These steps assume you are on Windows (PowerShell). Adapt commands for macOS/Linux shells as needed.

1. Clone the repository (if you haven't already):

   git clone <repo-url>
   cd Project_Charlie_Main

2. Install frontend dependencies and build (optional if you want to run dev server):

   # change to client folder
   cd frontend/client
   # install packages
   npm install
   # start dev server
   npm start

   # to create a production build
   npm run build

   After successful build, production files appear in `frontend/build/`.

3. Setup and run the Server backend

   The Server folder contains a Python backend. Create a virtual environment and install requirements:

   cd ../../Server
   python -m venv .venv
   .\.venv\Scripts\Activate.ps1
   pip install -r Requirements.txt

   Run the server (example):

   python Main.py

   Notes:
   - The server serves static files from `static/` and may expect built frontend in `frontend/build/` when deployed.
   - If `Main.py` requires configuration or environment variables, set them before running.

4. Setup and run the NLP microservice

   cd ..\NLP
   python -m venv .venv
   .\.venv\Scripts\Activate.ps1
   pip install -r requirements.txt

   # Run Flask app
   python app.py

   The NLP service typically serves on `http://127.0.0.1:5000/` by default. It includes `files/` for sample data and `templates/index.html` for a basic UI.

5. Optional: Run everything with Docker (if Dockerfiles provided)

   - `NLP/Dockerfile` exists and can be used to build the NLP service image.
   - You can containerize the Server if you create a Dockerfile for it.

Development notes
-----------------

Frontend
- Source lives in `frontend/client/src/`. The main entry point is `index.js` and `App.js`.
- Useful scripts in `frontend/client/package.json` are `start`, `build`, `test`, and `eject` (if created with Create React App).
- The built site is in `frontend/build/` and contains `index.html`, `static/js`, `static/css`, and `models/`.

Server
- Entry point: `Server/Main.py`.
- Dependencies listed in `Server/Requirements.txt`.
- Static assets used by the server are in `Server/static/` and `frontend/build/` if serving built frontend.

NLP
- Entry point: `NLP/app.py` (Flask).
- Uses `requirements.txt` in `NLP/` for its Python dependencies.

Configuration
-------------

- Environment variables
  - If the backend uses any secret keys, database URLs, or external service endpoints, set them in your shell or via a `.env` loader before starting the service.
- Ports
  - Default ports are typical: React dev server (3000), Flask NLP (5000), and backend (custom; check `Main.py`). Modify as needed.

Running a full local setup (example)
------------------------------------

1. Start the NLP service in one terminal:

   cd NLP
   .\.venv\Scripts\Activate.ps1
   python app.py

2. Start the Server in another terminal:

   cd Server
   .\.venv\Scripts\Activate.ps1
   python Main.py

3. Start frontend dev server in a third terminal:

   cd frontend\client
   npm start

4. Open `http://localhost:3000` to use the React app. If the React app is configured to proxy API calls to the backend, ensure `package.json` proxy is set or use CORS on the backend.

Troubleshooting
---------------

- npm install fails: delete `node_modules` and `package-lock.json` then re-run `npm install`.
- Python package errors: ensure virtualenv is activated and correct Python version is used.
- Port conflicts: change service port or stop the process occupying it.
- Missing environment variables: check `Server/Main.py` and `NLP/app.py` for required env vars; set them accordingly.

Security notes
--------------

- Do not commit secrets into the repository. Use environment variables or secret stores.
- If deploying to production, run build steps and serve the frontend statically through a CDN or reverse proxy.

Files of interest
-----------------

- `frontend/client/package.json` — frontend dependencies and scripts.
- `Server/Main.py` — backend entrypoint.
- `NLP/app.py` — NLP Flask app.
- `main.py` — top-level orchestrator or demo script.

Next steps and improvements
---------------------------

- Add clear configuration examples (example .env files) and document required environment variables.
- Add Dockerfiles for the Server and a docker-compose stack to run frontend, backend, and NLP together.
- Add unit/integration tests and a CI workflow (GitHub Actions).
- Add API documentation (OpenAPI/Swagger) for backend endpoints.

Contact / Maintainers
---------------------

Repository owner: venkataramanTB

License
-------

Please check the repository license (not included here). If you reuse code, respect the original license terms.
