-- =============================================
-- Kích hoạt extension UUID
-- =============================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================
-- BẢNG NGƯỜI DÙNG
-- =============================================
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMP NULL,
  username VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  gender VARCHAR(50) NULL,
  email VARCHAR(255) NULL,
  phone VARCHAR(50) NULL,
  avatar VARCHAR(255) NULL,
  position VARCHAR(100) NULL,
  address VARCHAR(255) NULL,
  auth_two_face VARCHAR(255) NULL,
  dob DATE NULL,
  status VARCHAR(50) NOT NULL DEFAULT 'active',
  service_supplier_id UUID NULL
);

-- =============================================
-- BẢNG VAI TRÒ
-- =============================================
CREATE TABLE roles (
  id BIGSERIAL PRIMARY KEY,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMP NULL,
  code VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  description VARCHAR(255) NULL
);

-- =============================================
-- BẢNG QUYỀN HẠN
-- =============================================
CREATE TABLE permissions (
  id BIGSERIAL PRIMARY KEY,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMP NULL,
  code VARCHAR(255) NOT NULL,
  module VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  description VARCHAR(255) NULL
);

-- =============================================
-- BẢNG NHÀ CUNG CẤP DỊCH VỤ
-- =============================================
CREATE TABLE service_suppliers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMP NULL,
  code VARCHAR(100) NOT NULL,
  name VARCHAR(255) NOT NULL,
  description TEXT NULL,
  address TEXT NULL,
  phone VARCHAR(50) NULL,
  email VARCHAR(255) NULL,
  website VARCHAR(255) NULL,
  logo VARCHAR(255) NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  metadata JSONB NULL
);

-- =============================================
-- BẢNG LOẠI DỊCH VỤ
-- =============================================
CREATE TABLE service_types (
  id BIGSERIAL PRIMARY KEY,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMP NULL,
  code VARCHAR(100) NOT NULL,
  name VARCHAR(255) NOT NULL,
  description TEXT NULL,
  icon VARCHAR(255) NULL,
  display_order INTEGER NOT NULL DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  metadata JSONB NULL
);

-- =============================================
-- BẢNG LIÊN KẾT NGƯỜI DÙNG - VAI TRÒ
-- =============================================
CREATE TABLE user_has_roles (
  id BIGSERIAL PRIMARY KEY,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMP NULL,
  user_id UUID NOT NULL,
  role_id BIGINT NOT NULL
);

-- =============================================
-- BẢNG LIÊN KẾT VAI TRÒ - QUYỀN HẠN
-- =============================================
CREATE TABLE role_has_permissions (
  id BIGSERIAL PRIMARY KEY,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMP NULL,
  role_id BIGINT NOT NULL,
  permission_id BIGINT NOT NULL
);

-- =============================================
-- BẢNG FORM DỊCH VỤ
-- =============================================
CREATE TABLE service_forms (
  id BIGSERIAL PRIMARY KEY,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMP NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT NULL,
  service_type_id BIGINT NOT NULL,
  service_supplier_id UUID NULL,
  user_id UUID NOT NULL,
  form_fields JSONB NOT NULL,
  form_data JSONB NULL,
  status VARCHAR(50) NOT NULL DEFAULT 'active',
  submitted_at TIMESTAMP NULL,
  processed_at TIMESTAMP NULL,
  processed_by UUID NULL,
  notes TEXT NULL,
  metadata JSONB NULL
);

-- =============================================
-- BẢNG PHẢN HỒI DỊCH VỤ
-- =============================================
CREATE TABLE feedbacks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMP NULL,
  user_id UUID NOT NULL,
  service_form_id BIGINT NOT NULL,
  store_id BIGINT NULL,
  form_data JSONB NULL,
  rating INTEGER NOT NULL,
  notes TEXT NULL,
  metadata JSONB NULL
);

-- =============================================
-- INDEXES
-- =============================================
-- Indexes cho bảng users
CREATE UNIQUE INDEX idx_users_username ON users(username) WHERE deleted_at IS NULL;
CREATE UNIQUE INDEX idx_users_email ON users(email) WHERE deleted_at IS NULL AND email IS NOT NULL;
CREATE UNIQUE INDEX idx_users_phone ON users(phone) WHERE deleted_at IS NULL AND phone IS NOT NULL;
CREATE INDEX idx_users_name ON users(name);
CREATE INDEX idx_users_position ON users(position);
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_users_service_supplier_id ON users(service_supplier_id);
CREATE INDEX idx_users_deleted_at ON users(deleted_at);

-- Indexes cho bảng roles
CREATE UNIQUE INDEX idx_roles_code ON roles(code) WHERE deleted_at IS NULL;
CREATE INDEX idx_roles_name ON roles(name);
CREATE INDEX idx_roles_deleted_at ON roles(deleted_at);

-- Indexes cho bảng permissions
CREATE UNIQUE INDEX idx_permissions_code ON permissions(code) WHERE deleted_at IS NULL;
CREATE INDEX idx_permissions_module ON permissions(module);
CREATE INDEX idx_permissions_name ON permissions(name);
CREATE INDEX idx_permissions_deleted_at ON permissions(deleted_at);

-- Indexes cho bảng service_suppliers
CREATE UNIQUE INDEX idx_service_suppliers_code ON service_suppliers(code) WHERE deleted_at IS NULL;
CREATE UNIQUE INDEX idx_service_suppliers_email ON service_suppliers(email) WHERE deleted_at IS NULL AND email IS NOT NULL;
CREATE UNIQUE INDEX idx_service_suppliers_phone ON service_suppliers(phone) WHERE deleted_at IS NULL AND phone IS NOT NULL;
CREATE INDEX idx_service_suppliers_name ON service_suppliers(name);
CREATE INDEX idx_service_suppliers_is_active ON service_suppliers(is_active);
CREATE INDEX idx_service_suppliers_deleted_at ON service_suppliers(deleted_at);

-- Indexes cho bảng service_types
CREATE UNIQUE INDEX idx_service_types_code ON service_types(code) WHERE deleted_at IS NULL;
CREATE INDEX idx_service_types_name ON service_types(name);
CREATE INDEX idx_service_types_is_active ON service_types(is_active);
CREATE INDEX idx_service_types_deleted_at ON service_types(deleted_at);

-- Indexes cho bảng user_has_roles
CREATE UNIQUE INDEX idx_user_has_roles_user_role ON user_has_roles(user_id, role_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_user_has_roles_user_id ON user_has_roles(user_id);
CREATE INDEX idx_user_has_roles_role_id ON user_has_roles(role_id);
CREATE INDEX idx_user_has_roles_deleted_at ON user_has_roles(deleted_at);

-- Indexes cho bảng role_has_permissions
CREATE UNIQUE INDEX idx_role_has_permissions_role_permission ON role_has_permissions(role_id, permission_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_role_has_permissions_role_id ON role_has_permissions(role_id);
CREATE INDEX idx_role_has_permissions_permission_id ON role_has_permissions(permission_id);
CREATE INDEX idx_role_has_permissions_deleted_at ON role_has_permissions(deleted_at);

-- Indexes cho bảng service_forms
CREATE INDEX idx_service_forms_service_type_id ON service_forms(service_type_id);
CREATE INDEX idx_service_forms_service_supplier_id ON service_forms(service_supplier_id);
CREATE INDEX idx_service_forms_user_id ON service_forms(user_id);
CREATE INDEX idx_service_forms_status ON service_forms(status);
CREATE INDEX idx_service_forms_submitted_at ON service_forms(submitted_at);
CREATE INDEX idx_service_forms_processed_by ON service_forms(processed_by);
CREATE INDEX idx_service_forms_deleted_at ON service_forms(deleted_at);

-- Indexes cho bảng feedbacks
CREATE INDEX idx_feedbacks_user_id ON feedbacks(user_id);
CREATE INDEX idx_feedbacks_service_form_id ON feedbacks(service_form_id);
CREATE INDEX idx_feedbacks_store_id ON feedbacks(store_id);
CREATE INDEX idx_feedbacks_rating ON feedbacks(rating);
CREATE INDEX idx_feedbacks_status ON feedbacks(status);
CREATE INDEX idx_feedbacks_deleted_at ON feedbacks(deleted_at);

-- =============================================
-- RÀNG BUỘC KHÓA NGOẠI
-- =============================================
-- Ràng buộc cho bảng users
ALTER TABLE users
  ADD CONSTRAINT fk_users_service_supplier_id FOREIGN KEY (service_supplier_id) REFERENCES service_suppliers(id);

-- Ràng buộc cho bảng user_has_roles
ALTER TABLE user_has_roles
  ADD CONSTRAINT fk_user_has_roles_user_id FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT fk_user_has_roles_role_id FOREIGN KEY (role_id) REFERENCES roles(id);

-- Ràng buộc cho bảng role_has_permissions
ALTER TABLE role_has_permissions
  ADD CONSTRAINT fk_role_has_permissions_role_id FOREIGN KEY (role_id) REFERENCES roles(id),
  ADD CONSTRAINT fk_role_has_permissions_permission_id FOREIGN KEY (permission_id) REFERENCES permissions(id);

-- Ràng buộc cho bảng service_forms
ALTER TABLE service_forms
  ADD CONSTRAINT fk_service_forms_service_type_id FOREIGN KEY (service_type_id) REFERENCES service_types(id),
  ADD CONSTRAINT fk_service_forms_service_supplier_id FOREIGN KEY (service_supplier_id) REFERENCES service_suppliers(id),
  ADD CONSTRAINT fk_service_forms_user_id FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT fk_service_forms_processed_by FOREIGN KEY (processed_by) REFERENCES users(id);

-- Ràng buộc cho bảng feedbacks
ALTER TABLE feedbacks
  ADD CONSTRAINT fk_feedbacks_user_id FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT fk_feedbacks_service_form_id FOREIGN KEY (service_form_id) REFERENCES service_forms(id);