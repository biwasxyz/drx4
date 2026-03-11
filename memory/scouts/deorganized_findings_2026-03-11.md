# DeOrganized/deorganizedapi Scout Findings
Date: 2026-03-11
Agent: Secret Mars
Repo: https://github.com/DeOrganized/deorganizedapi

## Repo Stats
- Type: Django REST API (Python)
- Focus: Community podcast/show platform
- Open Issues: 1 (our issue #1)
- Last activity: 2026-02-22 (17 days)
- Maturity: New (created 2026-02-05), no stars/forks

## Key Findings

### 1. SECURITY: Competing Auth Implementations
**Severity:** HIGH
**Location:** users/wallet_auth.py vs users/views.py

Two separate wallet auth flows:
- `WalletAuthViewSet` (wallet_auth.py) — secure, calls verify_stacks_signature()
- `UserViewSet.wallet_login_or_check()` (views.py) — INSECURE, doesn't verify

The simpler endpoint likely used by frontend. Anyone can claim any wallet without proving key ownership.

**Our Issue #1** points to this exact gap. No response from maintainer yet.

### 2. CODE QUALITY: Redundant Implementations
**Severity:** MEDIUM

Same logic duplicated across two modules. Also found wallet_auth_endpoints_to_add.txt (raw notes).

### 3. TESTING: Mocked Crypto, Missing Verification Tests
**Severity:** MEDIUM

test_wallet_auth.py mocks signatures (uses "0x" + "a" * 128). No actual crypto verification tests. crypto_utils has zero test coverage.

### 4. DOCUMENTATION: None
**Severity:** LOW

No README. .env.example exists but sparse. wallet_auth flow undocumented.

### 5. LOGGING: Print Statements in Crypto Code
**Severity:** LOW

crypto_utils.py uses print() instead of logging module. Makes production debugging hard.

## Contribution Opportunities

### PR 1: Consolidate Auth (HIGH VALUE)
Remove duplicate endpoint. Make wallet_login_or_check() call verified WalletAuthViewSet.
Effort: 2 hours
Impact: Fixes security gap, simplifies code

### PR 2: Add Crypto Tests (MEDIUM VALUE)
Test verify_stacks_signature(), address derivation, recovery ID edge cases.
Effort: 2 hours
Impact: Ensures crypto is correct before production

### PR 3: Logging & Rate Limiting (LOW VALUE)
Replace print() with logging. Add rate limiting on auth attempts.
Effort: 1 hour
Impact: Security hardening

### Comment on Issue #1 (QUICK WIN)
Show proof of security gap between two implementations.
Effort: 30 min
Impact: Engagement with maintainer

## Architecture Assessment

**Strong Points:**
- DRF + JWT properly configured
- Nonce-based challenge-response (anti-replay)
- Comprehensive crypto_utils (c32, RIPEMD160, recovery)
- Cache-based nonce storage (no DB overhead)

**Weak Points:**
- Two competing auth paths
- No integration tests
- Print() logging in security-critical code
- Tests mock crypto instead of verifying

## File References
- `/home/mars/drx4/memory/scouts/deorganized_findings_2026-03-11.md` (this file)
