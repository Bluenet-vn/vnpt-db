-- =============================================
-- Kích hoạt extension UUID
-- =============================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================
-- BẢNG NGƯỜI DÙNG
-- =============================================
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  deleted_at TIMESTAMP NULL,
  name VARCHAR(255) DEFAULT NULL,
  username VARCHAR(255) DEFAULT NULL,
  gender VARCHAR(50) DEFAULT NULL,
  email VARCHAR(255) DEFAULT NULL,
  phone VARCHAR(50) DEFAULT NULL,
  avatar VARCHAR(255) DEFAULT NULL,
  position VARCHAR(100) DEFAULT NULL,
  adrress VARCHAR(255) DEFAULT NULL,
  auth_two_face VARCHAR(255) DEFAULT NULL,
  dob DATE DEFAULT NULL,
  password VARCHAR(255) DEFAULT NULL,
  status VARCHAR(50) DEFAULT NULL
);

-- Tạo các indexes cho bảng users
CREATE INDEX idx_users_name ON users(name);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_phone ON users(phone);
CREATE INDEX idx_users_position ON users(position);
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_users_deleted_at ON users(deleted_at);

-- =============================================
-- BẢNG VAI TRÒ
-- =============================================
CREATE TABLE roles (
  id BIGSERIAL PRIMARY KEY,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  deleted_at TIMESTAMP NULL,
  name VARCHAR(255) DEFAULT NULL,
  code VARCHAR(255) DEFAULT NULL,
  description VARCHAR(255) DEFAULT NULL
);

-- Tạo các indexes cho bảng roles
CREATE INDEX idx_roles_name ON roles(name);
CREATE INDEX idx_roles_code ON roles(code);
CREATE INDEX idx_roles_deleted_at ON roles(deleted_at);

-- =============================================
-- BẢNG QUYỀN HẠN
-- =============================================
CREATE TABLE permissions (
  id BIGSERIAL PRIMARY KEY,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  deleted_at TIMESTAMP NULL,
  module VARCHAR(255) DEFAULT NULL,
  name VARCHAR(255) DEFAULT NULL,
  code VARCHAR(255) DEFAULT NULL,
  description VARCHAR(255) DEFAULT NULL
);

-- Tạo các indexes cho bảng permissions
CREATE INDEX idx_permissions_module ON permissions(module);
CREATE INDEX idx_permissions_name ON permissions(name);
CREATE INDEX idx_permissions_code ON permissions(code);
CREATE INDEX idx_permissions_deleted_at ON permissions(deleted_at);

-- =============================================
-- BẢNG LIÊN KẾT VAI TRÒ - QUYỀN HẠN
-- =============================================
CREATE TABLE role_has_permissions (
  id BIGSERIAL PRIMARY KEY,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  deleted_at TIMESTAMP NULL,
  role_id BIGINT DEFAULT NULL,
  permission_id BIGINT DEFAULT NULL
);

-- Tạo các indexes cho bảng role_has_permissions
CREATE INDEX idx_role_has_permissions_role_id ON role_has_permissions(role_id);
CREATE INDEX idx_role_has_permissions_permission_id ON role_has_permissions(permission_id);
CREATE INDEX idx_role_has_permissions_deleted_at ON role_has_permissions(deleted_at);

-- =============================================
-- BẢNG LIÊN KẾT NGƯỜI DÙNG - VAI TRÒ
-- =============================================
CREATE TABLE user_has_roles (
  id BIGSERIAL PRIMARY KEY,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  deleted_at TIMESTAMP NULL,
  user_id UUID DEFAULT NULL,
  role_id BIGINT DEFAULT NULL
);

-- Tạo các indexes cho bảng user_has_roles
CREATE INDEX idx_user_has_roles_user_id ON user_has_roles(user_id);
CREATE INDEX idx_user_has_roles_role_id ON user_has_roles(role_id);
CREATE INDEX idx_user_has_roles_deleted_at ON user_has_roles(deleted_at);

-- =============================================
-- RÀNG BUỘC KHÓA NGOẠI
-- =============================================
-- Ràng buộc cho bảng role_has_permissions
ALTER TABLE role_has_permissions
  ADD CONSTRAINT fk_role_has_permissions_role_id FOREIGN KEY (role_id) REFERENCES roles(id),
  ADD CONSTRAINT fk_role_has_permissions_permission_id FOREIGN KEY (permission_id) REFERENCES permissions(id);

-- Ràng buộc cho bảng user_has_roles
ALTER TABLE user_has_roles
  ADD CONSTRAINT fk_user_has_roles_user_id FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT fk_user_has_roles_role_id FOREIGN KEY (role_id) REFERENCES roles(id);


-- =============================================
-- BẢNG LOẠI DỊCH VỤ PHỤC VỤ KHÁCH HÀNG
-- =============================================
CREATE TABLE service_types (
  id BIGSERIAL PRIMARY KEY,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  deleted_at TIMESTAMP NULL,
  name VARCHAR(255) NOT NULL,
  code VARCHAR(100) NOT NULL,
  description TEXT DEFAULT NULL,
  icon VARCHAR(255) DEFAULT NULL,
  display_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  metadata JSONB DEFAULT NULL
);

-- Tạo các indexes cho bảng service_types
CREATE INDEX idx_service_types_name ON service_types(name);
CREATE INDEX idx_service_types_code ON service_types(code);
CREATE INDEX idx_service_types_is_active ON service_types(is_active);
CREATE INDEX idx_service_types_deleted_at ON service_types(deleted_at);