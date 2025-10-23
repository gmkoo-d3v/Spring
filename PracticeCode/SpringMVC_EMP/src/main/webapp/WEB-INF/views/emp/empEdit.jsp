<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>직원 정보 수정</title>
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
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
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
                <a href="${pageContext.request.contextPath}/emp/empDetail.do?empno=${emp.empno}" class="btn btn-outline-light">
                    <i class="bi bi-arrow-left"></i> 상세로
                </a>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="form-header">
                    <h2><i class="bi bi-pencil-square"></i> 직원 정보 수정</h2>
                    <p class="mb-0">직원 정보를 수정합니다</p>
                </div>

                <div class="form-card">
                    <form action="${pageContext.request.contextPath}/emp/empEdit.do" method="post">
                        <input type="hidden" name="empno" value="${emp.empno}">
                        
                        <div class="row g-3">
                            <!-- 사원번호 (읽기 전용) -->
                            <div class="col-md-6">
                                <label for="empno_display" class="form-label">
                                    <i class="bi bi-hash text-primary"></i> 사원번호
                                </label>
                                <input type="text" class="form-control" id="empno_display" 
                                       value="${emp.empno}" readonly disabled>
                                <div class="form-text">사원번호는 수정할 수 없습니다.</div>
                            </div>

                            <!-- 이름 -->
                            <div class="col-md-6">
                                <label for="ename" class="form-label">
                                    <i class="bi bi-person text-primary"></i> 이름 
                                    <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control" id="ename" name="ename" 
                                       value="${emp.ename}" required>
                            </div>

                            <!-- 직책 -->
                            <div class="col-md-6">
                                <label for="job" class="form-label">
                                    <i class="bi bi-briefcase text-primary"></i> 직책 
                                    <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" id="job" name="job" required>
                                    <option value="CLERK" ${emp.job == 'CLERK' ? 'selected' : ''}>CLERK (사원)</option>
                                    <option value="SALESMAN" ${emp.job == 'SALESMAN' ? 'selected' : ''}>SALESMAN (영업)</option>
                                    <option value="ANALYST" ${emp.job == 'ANALYST' ? 'selected' : ''}>ANALYST (분석가)</option>
                                    <option value="MANAGER" ${emp.job == 'MANAGER' ? 'selected' : ''}>MANAGER (매니저)</option>
                                    <option value="PRESIDENT" ${emp.job == 'PRESIDENT' ? 'selected' : ''}>PRESIDENT (사장)</option>
                                </select>
                            </div>

                            <!-- 매니저 -->
                            <div class="col-md-6">
                                <label for="mgr" class="form-label">
                                    <i class="bi bi-person-check text-primary"></i> 매니저 사원번호
                                </label>
                                <input type="number" class="form-control" id="mgr" name="mgr" 
                                       value="${emp.mgr}">
                            </div>

                            <!-- 입사일 -->
                            <div class="col-md-6">
                                <label for="hiredate" class="form-label">
                                    <i class="bi bi-calendar-event text-primary"></i> 입사일 
                                    <span class="text-danger">*</span>
                                </label>
                                <input type="date" class="form-control" id="hiredate" name="hiredate" 
                                       value="<fmt:formatDate value='${emp.hiredate}' pattern='yyyy-MM-dd'/>" required>
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
                                           value="${emp.sal}" step="0.01" required>
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
                                           value="${emp.comm}" step="0.01">
                                </div>
                            </div>

                            <!-- 부서번호 -->
                            <div class="col-md-6">
                                <label for="deptno" class="form-label">
                                    <i class="bi bi-building text-primary"></i> 부서번호 
                                    <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" id="deptno" name="deptno" required>
                                    <option value="10" ${emp.deptno == 10 ? 'selected' : ''}>10 - ACCOUNTING</option>
                                    <option value="20" ${emp.deptno == 20 ? 'selected' : ''}>20 - RESEARCH</option>
                                    <option value="30" ${emp.deptno == 30 ? 'selected' : ''}>30 - SALES</option>
                                    <option value="40" ${emp.deptno == 40 ? 'selected' : ''}>40 - OPERATIONS</option>
                                </select>
                            </div>
                        </div>

                        <!-- Alert -->
                        <div class="alert alert-warning mt-4" role="alert">
                            <i class="bi bi-exclamation-triangle"></i> 
                            수정하시기 전에 입력한 정보를 다시 한번 확인해주세요.
                        </div>

                        <!-- Buttons -->
                        <div class="d-flex gap-2 justify-content-center mt-4">
                            <button type="submit" class="btn btn-success btn-lg">
                                <i class="bi bi-check-circle"></i> 수정 완료
                            </button>
                            <a href="${pageContext.request.contextPath}/emp/empDetail.do?empno=${emp.empno}" 
                               class="btn btn-secondary btn-lg">
                                <i class="bi bi-x-circle"></i> 취소
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
