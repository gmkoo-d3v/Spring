package ncontroller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import dao.NoticeDao;
import vo.Notice;

@Controller
@RequestMapping("/customer")
public class CustomerController {
	
	@Autowired
	private NoticeDao noticeDao;
	
	// 게시판 목록보기
	@RequestMapping("/notice.htm")
	public String notice(
			@RequestParam(value="pg", required=false, defaultValue="1") int page,
			@RequestParam(value="f", required=false, defaultValue="TITLE") String field,
			@RequestParam(value="q", required=false, defaultValue="") String query,
			Model model) throws Exception {
		
		// query 값 처리
		String searchQuery = query.isEmpty() ? "%%" : query;
		
		// DAO 작업
		List<Notice> list = noticeDao.getNotices(page, field, searchQuery);
		
		// Model에 데이터 추가
		model.addAttribute("list", list);
		
		return "notice.jsp";
	}
	
	// 게시판 상세보기
	@RequestMapping("/noticeDetail.htm")
	public String noticeDetail(
			@RequestParam("seq") String seq,
			Model model) throws Exception {
		
		// DAO 작업
		Notice notice = noticeDao.getNotice(seq);
		
		// Model에 데이터 추가
		model.addAttribute("notice", notice);
		
		return "noticeDetail.jsp";
	}
	
	// 글쓰기 폼 보기 (GET)
	@RequestMapping(value="/noticeReg.htm", method=RequestMethod.GET)
	public String noticeReg() {
		return "noticeReg.jsp";
	}
	
	// 글쓰기 처리 (POST) - 파일 업로드 포함
	@RequestMapping(value="/noticeReg.htm", method=RequestMethod.POST)
	public String noticeRegPost(
			@RequestParam("title") String title,
			@RequestParam("content") String content,
			@RequestParam(value="file", required=false) MultipartFile file,
			javax.servlet.http.HttpServletRequest request) throws Exception {
		
		// 파일 업로드 처리
		String fileName = null;
		if(file != null && !file.isEmpty()) {
			// 업로드 폴더 경로 (실제 서버 경로)
			String uploadPath = request.getSession().getServletContext().getRealPath("/customer/upload/");
			
			// 폴더가 없으면 생성
			java.io.File uploadDir = new java.io.File(uploadPath);
			if(!uploadDir.exists()) {
				uploadDir.mkdirs();
			}
			
			// 파일명 생성 (중복 방지: 시간+원본파일명)
			String originalFileName = file.getOriginalFilename();
			fileName = System.currentTimeMillis() + "_" + originalFileName;
			
			// 파일 저장
			java.io.File saveFile = new java.io.File(uploadPath, fileName);
			file.transferTo(saveFile);
		}
		
		Notice notice = new Notice();
		notice.setTitle(title);
		notice.setContent(content);
		notice.setFileSrc(fileName);
		
		noticeDao.insert(notice);
		
		// 저장 후 목록으로 리다이렉트
		return "redirect:notice.htm";
	}
	
	// 수정 폼 보기 (GET)
	@RequestMapping(value="/noticeEdit.htm", method=RequestMethod.GET)
	public String noticeEdit(
			@RequestParam("seq") String seq,
			Model model) throws Exception {
		
		Notice notice = noticeDao.getNotice(seq);
		model.addAttribute("notice", notice);
		
		return "noticeEdit.jsp";
	}
	
	// 수정 처리 (POST) - 파일 업로드 포함
	@RequestMapping(value="/noticeEdit.htm", method=RequestMethod.POST)
	public String noticeEditPost(
			@RequestParam("seq") String seq,
			@RequestParam("title") String title,
			@RequestParam("content") String content,
			@RequestParam(value="file", required=false) MultipartFile file,
			javax.servlet.http.HttpServletRequest request) throws Exception {
		
		// 파일 업로드 처리
		String fileName = null;
		if(file != null && !file.isEmpty()) {
			// 업로드 폴더 경로
			String uploadPath = request.getSession().getServletContext().getRealPath("/customer/upload/");
			
			// 폴더가 없으면 생성
			java.io.File uploadDir = new java.io.File(uploadPath);
			if(!uploadDir.exists()) {
				uploadDir.mkdirs();
			}
			
			// 파일명 생성
			String originalFileName = file.getOriginalFilename();
			fileName = System.currentTimeMillis() + "_" + originalFileName;
			
			// 파일 저장
			java.io.File saveFile = new java.io.File(uploadPath, fileName);
			file.transferTo(saveFile);
		}
		
		Notice notice = new Notice();
		notice.setSeq(seq);
		notice.setTitle(title);
		notice.setContent(content);
		notice.setFileSrc(fileName);
		
		noticeDao.update(notice);
		
		// 수정 후 상세보기로 리다이렉트
		return "redirect:noticeDetail.htm?seq=" + seq;
	}
	
	// 삭제 처리
	@RequestMapping("/noticeDel.htm")
	public String noticeDel(@RequestParam("seq") String seq) throws Exception {
		
		noticeDao.delete(seq);
		
		// 삭제 후 목록으로 리다이렉트
		return "redirect:notice.htm";
	}
}
