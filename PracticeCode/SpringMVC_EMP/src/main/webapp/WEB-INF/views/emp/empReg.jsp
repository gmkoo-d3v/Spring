<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>직원 등록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .form-card {
            background: white;
            border-radius: 0.5rem;
            box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075);
            padding: 2rem;
        }
        .form-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1.5rem;
            border-radius: 0.5rem;
            margin-bottom: 2rem;
            text-align: center;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary mb-4">
        <div class="container-fluid">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/index.do">
                <i class="bi bi-people-fill"></i> EMP Management
            </a>
            <div class="ms-auto">
                <a href="${pageContext.request.contextPath}/emp/emp.do" class="btn btn-outline-light">
                    <i class="bi bi-arrow-left"></i> 목록으로
                </a>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="form-header">
                    <h2><i class="bi bi-person-plus-fill"></i> 신규 직원 등록</h2>
                    <p class="mb-0">새로운 직원의 정보를 입력해주세요</p>
                </div>

                <div class="form-card">
                    <form action="${pageContext.request.contextPath}/emp/empReg.do" method="post">
                        <div class="row g-3">
                            <!-- 사원번호 -->
                            <div class="col-md-6">
                                <label for="empno" class="form-label">
                                    <i class="bi bi-hash text-primary"></i> 사원번호 
                                    <span class="text-danger">*</span>
                                </label>
                                <input type="number" class="form-control" id="empno" name="empno" 
                                       placeholder="예: 7900" required>
                            </div>

                            <!-- 이름 -->
                            <div class="col-md-6">
                                <label for="ename" class="form-label">
                                    <i class="bi bi-person text-primary"></i> 이름 
                                    <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control" id="ename" name="ename" 
                                       placeholder="예: 홍길동" required>
                            </div>

                            <!-- 직책 -->
                            <div class="col-md-6">
                                <label for="job" class="form-label">
                                    <i class="bi bi-briefcase text-primary"></i> 직책 
                                    <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" id="job" name="job" required>
                                    <option value="">선택하세요</option>
                                    <option value="CLERK">CLERK (사원)</option>
                                    <option value="SALESMAN">SALESMAN (영업)</option>
                                    <option value="ANALYST">ANALYST (분석가)</option>
                                    <option value="MANAGER">MANAGER (매니저)</option>
                                    <option value="PRESIDENT">PRESIDENT (사장)</option>
                                </select>
                            </div>

                            <!-- 매니저 -->
                            <div class="col-md-6">
                                <label for="mgr" class="form-label">
                                    <i class="bi bi-person-check text-primary"></i> 매니저 사원번호
                                </label>
                                <input type="number" class="form-control" id="mgr" name="mgr" 
                                       placeholder="예: 7839">
                            </div>

                            <!-- 입사일 -->
                            <div class="col-md-6">
                                <label for="hiredate" class="form-label">
                                    <i class="bi bi-calendar-event text-primary"></i> 입사일 
                                    <span class="text-danger">*</span>
                                </label>
                                <input type="date" class="form-control" id="hiredate" name="hiredate" required>
                            </div>

                            <!-- 급여 -->
                            <div class="col-md-6">
                                <label for="sal" class="form-label">
                                    <i class="bi bi-cash-coin text-primary"></i> 급여 
                                    <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text">$</span>
                                    <input type="number" class="form-control" id="sal" name="sal" 
                                           placeholder="예: 3000" step="0.01" required>
                                </div>
                            </div>

                            <!-- 커미션 -->
                            <div class="col-md-6">
                                <label for="comm" class="form-label">
                                    <i class="bi bi-gift text-primary"></i> 커미션
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text">$</span>
                                    <input type="number" class="form-control" id="comm" name="comm" 
                                           placeholder="예: 500" step="0.01">
                                </div>
                                <div class="form-text">선택사항입니다.</div>
                            </div>

                            <!-- 부서번호 -->
                            <div class="col-md-6">
                                <label for="deptno" class="form-label">
                                    <i class="bi bi-building text-primary"></i> 부서번호 
                                    <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" id="deptno" name="deptno" required>
                                    <option value="">선택하세요</option>
                                    <option value="10">10 - ACCOUNTING</option>
                                    <option value="20">20 - RESEARCH</option>
                                    <option value="30">30 - SALES</option>
                                    <option value="40">40 - OPERATIONS</option>
                                </select>
                            </div>
                        </div>

                        <!-- Alert for required fields -->
                        <div class="alert alert-info mt-4" role="alert">
                            <i class="bi bi-info-circle"></i> 
                            <span class="text-danger">*</span> 표시는 필수 입력 항목입니다.
                        </div>

                        <!-- Buttons -->
                        <div class="d-flex gap-2 justify-content-center mt-4">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="bi bi-check-circle"></i> 등록
                            </button>
                            <a href="${pageContext.request.contextPath}/emp/emp.do" class="btn btn-secondary btn-lg">
                                <i class="bi bi-x-circle"></i> 취소
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Set today's date as default for hiredate
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('hiredate').value = today;
        });
    </script>
</body>
</html>
