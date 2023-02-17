# Ones 应用中心 API (ones-ruby-sdk)

## 安装
添加下面代码到应用的 Gemfile:

```ruby
gem 'ones-sdk', github: 'mycolorway/ones-ruby-sdk', branch: 'master'
```

然后执行:

```bash
$ bundle install
```

## 使用

#### 初始化

```ruby
# config/initializers/ones.rb

Ones.configure do |config|
  # Ones 应用中心配置
  config.default_client_id     = 'xxx' # 应用 client ID
  config.default_client_secret = 'xxx' # 应用 client secret
  config.app_center_base_url   = 'http://localhost:3001' # Ones 应用中心 API 地址

  # Ones API 配置
  config.api_base_url          = 'http://localhost:3001' # Ones API 地址

  # 公共配置
  config.http_timeout_options  = { write: 2, connect: 5, read: 15 } # 请求的 timeout 参数（非必需）
end
```

#### 应用身份 API

```ruby
# -------------------- 应用 --------------------
#
# 用户凭证校验
Ones::Api.default.app_center.check_user('user_uuid', 'token')

# -------------------- 组织 --------------------
#
# 获取服务凭证
Ones::Api.default.org.app_credential('org_uuid')

# 获取当前应用在指定组织指定用户下的ConstraintMap
Ones::Api.default.org.constraint_by_user('org_uuid', 'user_uuid')

# 获取当前应用在指定组织的有效 License
Ones::Api.default.org.license('org_uuid')

# 获取当前应用在指定组织已授权用户的UUID列表
Ones::Api.default.org.grant_uuids('org_uuid')

# -------------------- 团队 --------------------
#
# 获取组织下属团队列表
Ones::Api.default.team.list('org_uuid')

# 批量获取团队信息
Ones::Api.default.user.teams('org_uuid', %w[aaaabbbb xxxxyyyy])

# -------------------- 部门 --------------------
#
# 获取指定团队的部门列表（产品确认过可以接受空部门）
Ones::Api.default.department.list('team_uuid')

# -------------------- 用户 --------------------
#
# 批量获取指定用户信息
Ones::Api.default.user.batch('org_uuid', %w[xxxxyyyy aaaabbbb])

# 批量获取指定用户的所属团队
Ones::Api.default.user.teams('org_uuid', %w[xxxxyyyy aaaabbbb])

# 批量获取用户在指定团队的所属部门
Ones::Api.default.user.departments('team_uuid', %w[xxxxyyyy aaaabbbb])

```

#### 用户身份 API
```ruby
# 使用用户在 ones 系统的 user_uuid 与 token 生成用户身份接口对象
$ones_api = Ones::Api.new(client_id: 'user_uuid', client_secret: 'token', mode: :api)

# -------------------- 组织 --------------------
#
# 获取组织的业务配置
# Wiki 相关主要关注：wps_config、wiz_config、wiki_config
$ones_api.org.stamps_data('org_uuid')
```


## 运行测试
```bash
$ rake
```
