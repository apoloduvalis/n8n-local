# n8n Local Automation Project

This project runs a containerized instance of n8n (Node8 Automation) community edition with support for task runners and external webhook integrations. It includes pre-built automation workflows for handling Telegram messages and form submissions.

## Prerequisites

- **Docker** and **Docker Compose** installed on your system
- **ngrok** account (free tier available at [ngrok.com](https://ngrok.com))
- **Node.js/npm** (if you plan to modify workflows locally)
- Telegram account with a Bot Token (for Telegram-based workflows)

## Installation

### 1. Clone/Download the Project

```bash
cd ~/Documents/n8n-local
```

### 2. Install ngrok

If you haven't already, download and install ngrok from [ngrok.com](https://ngrok.com/download).

### 3. Create Environment Configuration

Create a `.env` file in the project root directory with the following variables:

```bash
N8N_RUNNERS_AUTH_TOKEN=<your-secure-token>
NGROK_AUTHTOKEN=<your-ngrok-auth-token>
NGROK_DOMAIN=<your-ngrok-domain>
WEBHOOK_URL=https://<your-ngrok-domain>
```

### Environment Variables Explained

| Variable | Description |
|----------|-------------|
| `N8N_RUNNERS_AUTH_TOKEN` | A secure token for communication between n8n and task runners. Generate a random 64-character hex string (e.g., using `openssl rand -hex 32`) |
| `NGROK_AUTHTOKEN` | Your ngrok authentication token from your [ngrok dashboard](https://dashboard.ngrok.com) |
| `NGROK_DOMAIN` | Your reserved ngrok domain (e.g., `my-app-domain.ngrok-free.dev`) |
| `WEBHOOK_URL` | The full HTTPS URL to access your n8n instance externally: `https://<your-ngrok-domain>` |

### Getting ngrok Credentials

1. Create a free account at [ngrok.com](https://ngrok.com)
2. Sign in and go to the [Auth Token page](https://dashboard.ngrok.com/auth/your-authtoken)
3. Copy your auth token and add it to the `NGROK_AUTHTOKEN` variable
4. Create a static domain on the [Domains page](https://dashboard.ngrok.com/domains) and add it to `NGROK_DOMAIN` and `WEBHOOK_URL`

## Configuration

### 1. Update ngrok Domain

Edit [ngrok.yml](ngrok.yml) and replace the domain with your own:

```yaml
version: "3"

tunnels:
  n8n:
    proto: http
    addr: 5678
    domain: your-ngrok-domain.ngrok-free.dev  # ← Change this
```

### 2. Configure Telegram Credentials (if using Telegram workflows)

If you want to use the Telegram-based workflows, you'll need:

1. A Telegram Bot Token from [BotFather](https://t.me/botfather)
2. Your personal Telegram User ID

When n8n is running, you'll add the Telegram Bot Token credentials through the n8n UI.

## Usage

### 1. Start the Project

Run the startup script:

```bash
./start_n8n.sh
```

This will:
- Start the n8n Docker container
- Start the task runners container
- Establish the ngrok tunnel to your n8n instance

### 2. Access n8n

- **Local access**: http://localhost:5678
- **External access** (via Telegram webhooks, etc.): https://your-ngrok-domain.ngrok-free.dev

### 3. Import Workflows

The example workflows are located in the [workflows_source](workflows_source/) folder:

1. In the n8n UI, click on **Workflows** in the left sidebar
2. Click the **+** icon to create a new workflow
3. Click **File** → **Import from file**
4. Select one of the workflow JSON files from `workflows_source/`:
   - `FixIt by Telegram.json` - Responds to Telegram messages
   - `FixIt by Form.json` - Handles form submissions
   - `Evaluate Product query.json` - Processes product queries
   - `Test Evaluate Product Query.json` - Test workflow

### 4. Configure Imported Workflows

After importing workflows, you need to configure them with your credentials:

#### For Telegram Workflows (`FixIt by Telegram.json`)

1. **Update Telegram Account ID**: 
   - Open the imported workflow
   - Find the node that contains the hardcoded Telegram ID `1234567890`
   - Replace it with your own Telegram User ID
   - You can get your ID from [@userinfobot](https://t.me/userinfobot) on Telegram

2. **Add Telegram Credentials**:
   - Click on any Telegram node
   - Click on the Telegram credentials dropdown
   - Select "Create New Credential"
   - Add your Bot Token from BotFather

3. **Enable the Webhook**:
   - Click the "Listen" button to activate the Telegram trigger
   - The webhook URL will be automatically configured using your WEBHOOK_URL

## Project Structure

```
n8n-local/
├── docker-compose.yml          # Docker services configuration
├── Dockerfile.runners          # Task runners Docker image definition
├── n8n-task-runners.json       # Task runners configuration
├── requirements.txt            # Python dependencies for task runners
├── ngrok.yml                   # ngrok tunnel configuration
├── start_n8n.sh               # Startup script
├── .env                        # Environment variables (create this)
├── credentials/               # Credential files storage
├── n8n_data/                 # n8n persistent data (database, workflows, etc.)
├── workflows_source/         # Source workflow files to import
├── ssh/                      # SSH configuration directory
└── README.md                 # This file
```

## Task Runners

This project includes support for Python and JavaScript task runners, allowing n8n to execute code in sandboxed environments.

**Installed Python Packages** (from [requirements.txt](requirements.txt)):
- `numpy` - Numerical computing
- `pandas` - Data manipulation
- `python-Levenshtein` - String similarity

You can extend the Python environment by adding packages to `requirements.txt` and rebuilding the Docker image.

## Troubleshooting

### Port Already in Use

If port 5678 is already in use:
```bash
# Find process using port 5678
lsof -i :5678
# Kill the process
kill -9 <PID>
```

### Docker Container Won't Start

```bash
# View container logs
docker-compose logs n8n

# Restart containers
docker-compose restart
```

### ngrok Tunnel Not Working

1. Check your ngrok auth token is correct in `.env`
2. Verify your domain is still available in your ngrok dashboard
3. Restart the ngrok tunnel:
```bash
# Stop the current process (Ctrl+C)
# Then run start_n8n.sh again
```

### Workflows Not Receiving Webhooks

1. Verify `WEBHOOK_URL` is set correctly in `.env`
2. Check that ngrok tunnel is active and shows "Online" status
3. In workflow, verify webhook URL matches your ngrok domain
4. Test with curl:
```bash
curl https://your-ngrok-domain.ngrok-free.dev
```

## Stopping the Project

```bash
# From the n8n-local directory
docker-compose down
```

## Next Steps

1. Explore the pre-built workflows in `workflows_source/`
2. Modify workflows to suit your needs
3. Add additional Python packages to `requirements.txt` for extended functionality
4. Create new workflows directly in the n8n UI
5. Set up additional integrations through the n8n credentials UI

## Additional Resources

- [n8n Documentation](https://docs.n8n.io/)
- [n8n Community](https://community.n8n.io/)
- [ngrok Documentation](https://ngrok.com/docs)
- [Docker Documentation](https://docs.docker.com/)

## License

This project uses n8n community edition. Please refer to the [n8n license](https://github.com/n8n-io/n8n/blob/master/LICENSE.md).
