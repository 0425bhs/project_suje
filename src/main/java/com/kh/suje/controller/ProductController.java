package com.kh.suje.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.kh.suje.dao.ProductDAO;
import com.kh.suje.util.Paging;
import com.kh.suje.vo.ProductVO;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ProductController {

    private final ProductDAO productdao;

    @GetMapping(value={"/","/product/list.do"})
    public String productList(Model model,Integer page){
       
        int nowPage = 1;

        if (page != null) {
            nowPage=page;
        }

        int blockList=10; //한 페이지에 보여줄 상품 수
        int blockPage=5; //페이지 번호 개수

        int rowTotal = productdao.product_cnt();
        int start=(nowPage - 1)*blockList;

        Map<String, Object> map = new HashMap<>();
        map.put("start",start);
        map.put("blockList",blockList);

        List<ProductVO> list=productdao.product_list(map);

        String pageMenu=Paging.getPaging("/product/list.do",nowPage,rowTotal,blockList,blockPage);

        model.addAttribute("list",list);
        model.addAttribute("pageMenu",pageMenu);

        return "product/product_list";
    }

    @GetMapping("/product_detail.do")
    public String product_detail_form(int product_id,Model model){
        ProductVO vo=productdao.product_one(product_id);
        model.addAttribute("vo",vo);
        return "/product/product_detail";
    }   


    @GetMapping("/seller_product_insert.do")
    public String seller_product_insert_form(){
        return "/seller/seller_product_insert_form";
    }


    @PostMapping("/seller_product_insert.do")
    @ResponseBody
    public Map<String,Object> seller_product_insert(ProductVO vo) throws Exception{

        String savePath="c:/upload/";
        File dir= new File(savePath);
        if(!dir.exists()){
            dir.mkdirs();
        }

        MultipartFile image_L=vo.getImage_l_file();
        String filename_l="no_file";

        if(image_L!=null && !image_L.isEmpty()){
            filename_l=image_L.getOriginalFilename();
            File savFile=new File(savePath,filename_l);

            if(savFile.exists()){
                long time=System.currentTimeMillis();
                filename_l=String.format("%d_%s",time, filename_l);
                savFile=new File(savePath,filename_l);
            }

            image_L.transferTo(savFile);
        }

        MultipartFile image_S=vo.getImage_s_file();
        String filename_s="no_file";

        if(image_S!=null && !image_S.isEmpty()){
            filename_s=image_S.getOriginalFilename();
            File savFile=new File(savePath,filename_s);

            if(savFile.exists()){
                long time=System.currentTimeMillis();
                filename_s=String.format("%d_%s",time, filename_s);
                savFile=new File(savePath,filename_s);
            }

            image_S.transferTo(savFile);
        }

        if (filename_l.equals("no_file")) {
            vo.setImage_l("no_file");
        } else {
            vo.setImage_l("/upload/" + filename_l);
        }

        if (filename_s.equals("no_file")) {
            vo.setImage_s("no_file");
        } else {
            vo.setImage_s("/upload/" + filename_s);
        }

        vo.setStatus("APPROVED");//테스트용 삭제 예정

        int res=productdao.seller_product_insert(vo);

        Map<String,Object> map=new HashMap<>();
        map.put("result", res);

        return map;
    }


    @GetMapping("/seller_product_modify.do")
    public String seller_product_modify_form(int product_id, Model model){
        ProductVO vo = productdao.product_one(product_id);
        model.addAttribute("vo", vo);
        return "seller/seller_product_modify_form";
    }


    @PostMapping("/seller_product_modify.do")
    @ResponseBody
    public Map<String,Object> seller_product_modify(ProductVO vo,String ori_image_l,String ori_image_s,String del_image_l,String del_image_s)throws Exception{
        String savePath = "c:/upload/";
        File dir = new File(savePath);

        if (!dir.exists()) {
            dir.mkdirs();
        }

        String image_l_name = "no_file";

        if (vo.getImage_l_file() != null && !vo.getImage_l_file().isEmpty()) {
            image_l_name = vo.getImage_l_file().getOriginalFilename();
            File saveFile = new File(savePath, image_l_name);

            if (saveFile.exists()) {
                long time = System.currentTimeMillis();
                image_l_name = String.format("%d_%s", time, image_l_name);
                saveFile = new File(savePath, image_l_name);
            }

            vo.getImage_l_file().transferTo(saveFile);

        } else if (ori_image_l != null && !ori_image_l.equals("no_file")) {
            image_l_name = ori_image_l;
        }

        String image_s_name = "no_file";

        if (vo.getImage_s_file() != null && !vo.getImage_s_file().isEmpty()) {
            image_s_name = vo.getImage_s_file().getOriginalFilename();
            File saveFile = new File(savePath, image_s_name);

            if (saveFile.exists()) {
                long time = System.currentTimeMillis();
                image_s_name = String.format("%d_%s", time, image_s_name);
                saveFile=new File(savePath, image_s_name);
            }

            vo.getImage_s_file().transferTo(saveFile);

        } else if (ori_image_s!=null && !ori_image_s.equals("no_file")) {
            image_s_name = ori_image_s;
        }

        vo.setImage_l(image_l_name.equals("no_file") ? "no_file":"/upload/"+image_l_name);
        vo.setImage_s(image_s_name.equals("no_file") ? "no_file":"/upload/"+image_s_name);

        int res = productdao.seller_product_modify(vo);

        if (res == 1) {
            if (del_image_l != null && !del_image_l.equals("no_file")) {
                File delFile = new File(savePath, del_image_l.replace("/upload/", ""));

                if (vo.getImage_l_file()!=null && !vo.getImage_l_file().isEmpty()) {
                    if (delFile.exists()) {
                        delFile.delete();
                    }
                }
            }

            if (del_image_s!=null && !del_image_s.equals("no_file")) {
                File delFile=new File(savePath, del_image_s.replace("/upload/", ""));

                if (vo.getImage_s_file() != null && !vo.getImage_s_file().isEmpty()) {
                    if (delFile.exists()) {
                        delFile.delete();
                    }
                }
            }
        }

        Map<String, Object> map = new HashMap<>();
        map.put("result",res);
        map.put("product_id",vo.getProduct_id());

        return map;
    }


    @GetMapping("/all_list.do")
    String allProductList(Model model,Integer page){
        
        int nowPage = 1;

        if (page != null) {
            nowPage=page;
        }

        int blockList=10;
        int blockPage=5;

        int rowTotal = productdao.product_cnt();
        int start=(nowPage - 1)*blockList;

        Map<String, Object> map = new HashMap<>();
        map.put("start",start);
        map.put("blockList",blockList);

        List<ProductVO> list=productdao.product_list(map);

        String pageMenu=Paging.getPaging("/product/list.do",nowPage,rowTotal,blockList,blockPage);

        model.addAttribute("list",list);
        model.addAttribute("pageMenu",pageMenu);
        return "product/product_all_list";
    }


    @GetMapping("/category_list.do")
    public String product_category_list(Model model,Integer page,int category_id) {

        int nowPage = 1;

        if (page != null) {
            nowPage = page;
        }

        int blockList = 10;
        int blockPage = 5;

        int start = (nowPage - 1) * blockList;

        Map<String, Object> map = new HashMap<>();
        map.put("category_id", category_id);
        map.put("start", start);
        map.put("blockList", blockList);

        int rowTotal = productdao.product_category_cnt(map);

        List<ProductVO> list = productdao.product_category_list(map);

        String pageMenu = Paging.getPaging(
            "/category_list.do?category_id=" + category_id,
            nowPage,
            rowTotal,
            blockList,
            blockPage
        );

        model.addAttribute("list", list);
        model.addAttribute("pageMenu", pageMenu);
        model.addAttribute("category_id", category_id);
        return "product/product_list";
    } 


    @GetMapping("/product_sale.do")
    public String product_sale_list(Model model,Integer page){
        int nowPage = 1;

        if (page != null) {
            nowPage = page;
        }

        int blockList = 10;
        int blockPage = 5;

        int rowTotal = productdao.product_sale_cnt();
        int start = (nowPage - 1) * blockList;

        Map<String, Object> map = new HashMap<>();
        map.put("start", start);
        map.put("blockList", blockList);

        List<ProductVO> list = productdao.product_sale_list(map);

        String pageMenu = Paging.getPaging(
            "/product/sale_list.do",
            nowPage,
            rowTotal,
            blockList,
            blockPage
        );

        model.addAttribute("list", list);
        model.addAttribute("pageMenu", pageMenu);
        return "product/product_sale_list";
    }


    
}
