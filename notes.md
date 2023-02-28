# Create virtual env
python3 -m venv env

# Activate env
source ./env/bin/activate

# Install
pip install -r requirements.txt

# Install fast api
#pip install fastapi

# Install uvicorn
#pip install "uvicorn[standard]"

# Start server
./env/bin/uvicorn app.main:app --reload

# Redoc
http://127.0.0.1:8000/redoc

# Swagger UI
http://127.0.0.1:8000/docs
