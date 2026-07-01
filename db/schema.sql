-- Tabla: users
CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    rfc VARCHAR(13) UNIQUE NOT NULL,
    password_digest VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'user',
    address VARCHAR(255),
    phone VARCHAR(50),
    website VARCHAR(255),
    creator_id BIGINT REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: sessions
CREATE TABLE IF NOT EXISTS sessions (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token VARCHAR(255) NOT NULL UNIQUE,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: collaborators
CREATE TABLE IF NOT EXISTS collaborators (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    rfc VARCHAR(13) NOT NULL,
    fiscal_address TEXT NOT NULL,
    curp VARCHAR(18) NOT NULL,
    social_security_number VARCHAR(20) NOT NULL,
    start_date DATE NOT NULL,
    contract_type VARCHAR(50) NOT NULL,
    department VARCHAR(100) NOT NULL,
    position VARCHAR(100) NOT NULL,
    daily_salary DECIMAL(10,2) NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    entity_key VARCHAR(20) NOT NULL,
    state VARCHAR(50) NOT NULL,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Índices
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_rfc ON users(rfc);
CREATE INDEX idx_sessions_user_id ON sessions(user_id);
CREATE INDEX idx_sessions_token ON sessions(token);
CREATE INDEX idx_collaborators_user_id ON collaborators(user_id);

-- Triggers para updated_at
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_updated_at 
    BEFORE UPDATE ON users 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_sessions_updated_at 
    BEFORE UPDATE ON sessions 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_collaborators_updated_at 
    BEFORE UPDATE ON collaborators 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at();