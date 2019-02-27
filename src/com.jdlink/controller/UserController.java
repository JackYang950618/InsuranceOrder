package com.jdlink.controller;

import com.jdlink.domain.User;
import com.jdlink.domain.dataItem.DataDictionary;
import com.jdlink.domain.dataItem.DataDictionaryItem;
import com.jdlink.service.DataDictionaryService;
import com.jdlink.service.UserService;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class UserController {

    @Autowired
    UserService userService;
    @Autowired
    DataDictionaryService dataDictionaryService;


    /**
     * 验证登录账号和密码
     *
     * @param user
     * @param session
     * @param request
     * @return
     */
    @RequestMapping(value = "/CheckUserInfo", method = RequestMethod.POST)
    public ModelAndView CheckUserInfo(User user, HttpSession session, HttpServletRequest request) {
        ModelAndView mav = new ModelAndView();
        try {
            // 查询参数
            if (user.getUserName().equals("") || user.getPassword().equals("")) {
                mav.addObject("status", "fail");
                mav.addObject("message", "账号或用户名为空！");
            }
            List<User> userList = userService.getUserByUserNameAndPassword(user);
            // 更新用户，通过数据查询后得到的用户为准
            if (userList.size() > 0) {
                user = userList.get(0);
                session.setAttribute("user", user); // 将登陆账户存储到session中
                // 放入jsp路径
                mav.setViewName("redirect:/orderList");
            } else {
                mav.addObject("status", "fail");
                mav.addObject("message", "账号或密码错误！");
                mav.setViewName("signin");
            }
        } catch (Exception e) {
            e.printStackTrace();
            mav.addObject("status", "fail");
            mav.addObject("message", "服务器异常！");
            mav.setViewName("signin");
        }
        return mav;
    }

    /**
     * 获取当前登陆用户
     *
     * @param session
     * @return
     */
    @RequestMapping(value = "/getCurrentUserInfo", method = RequestMethod.GET)
    public ModelAndView getCurrentUserInfo(HttpSession session) {
        ModelAndView mav = new ModelAndView();
        try {
            User user = (User) session.getAttribute("user");   // 获取用户信息
            mav.addObject("status", "success");
            mav.addObject("message", "获取成功！");
            mav.addObject("user", user);
        } catch (Exception e) {
            e.printStackTrace();
            mav.addObject("status", "fail");
            mav.addObject("message", "获取失败！");
        }
        return mav;
    }

    /**
     * 获取用户管理页面数据
     *
     * @return
     */
    @RequestMapping("/accountManage")
    public ModelAndView listUser(HttpSession session) {
        ModelAndView mav = new ModelAndView();
        User user = (User) session.getAttribute("user");   // 获取用户信息
        if (user != null && user.getUserName().equals("root")) {
            try {
                List<User> userList = userService.listUser();  // 获取所有用户
                mav.addObject("status", "success");
                mav.addObject("message", "获取成功！");
                mav.addObject("userList", userList);
            } catch (Exception e) {
                e.printStackTrace();
                mav.addObject("status", "fail");
                mav.addObject("message", "获取失败！");
            }
            mav.setViewName("accountManage");
        } else if(user == null){
            mav.setViewName("redirect:/signin");
        }else{
            //modelAndView.addObject("checkMessage","该账号无权限进入！");
            mav.setViewName("redirect:/orderList");
        }

        return mav;
    }

    /**
     * 获取公司下拉框数据
     * @return
     */
    @RequestMapping("getCompanyAndDepartmentAndTeamList")
    @ResponseBody
    public String getCompanyAndDepartmentAndTeamList() {
        JSONObject res = new JSONObject();
        try {
            List<DataDictionaryItem> companyList = dataDictionaryService.getDataDictionaryItemListByDataDictionaryId(1);
           // List<DataDictionaryItem> departmentList = dataDictionaryService.getDataDictionaryItemListByDataDictionaryId(2);
        //    List<DataDictionaryItem> teamList = dataDictionaryService.getDataDictionaryItemListByDataDictionaryId(3);
            // 计算最后页位置
            JSONArray companyList1 = JSONArray.fromArray(companyList.toArray(new DataDictionaryItem[companyList.size()]));
          //  JSONArray departmentList1 = JSONArray.fromArray(departmentList.toArray(new DataDictionaryItem[departmentList.size()]));
        //    JSONArray teamList1 = JSONArray.fromArray(teamList.toArray(new DataDictionaryItem[teamList.size()]));
            res.put("companyList", companyList1);
         //   res.put("departmentList", departmentList1);
         //   res.put("teamList", teamList1);
            res.put("status", "success");
            res.put("message", "下拉框数据获取成功!");
        } catch (Exception e) {
            e.printStackTrace();
            res.put("status", "fail");
            res.put("message", "下拉框数据获取失败！");
        }
        // 返回结果
        return res.toString();
    }

    /**
     * 导航栏跳转到账号管理页面
     */
    @RequestMapping(value = "/checkUserIsAdministrator")
    public ModelAndView checkUserIsAdministrator(ModelAndView modelAndView, HttpSession session) {
        User user = (User) session.getAttribute("user");   // 获取用户信息
        if (user != null && user.getUserName().equals("root")) {
            modelAndView.setViewName("redirect:/accountManage");
        } else if(user == null){
            modelAndView.setViewName("redirect:/signin");
        }else{
            //modelAndView.addObject("checkMessage","该账号无权限进入！");
            modelAndView.setViewName("redirect:/orderList");
        }
        return modelAndView;
    }

    /**
     * 新增用户
     *
     * @param user
     * @return
     */
    @RequestMapping("addUser")
    @ResponseBody
    public String addUser(@RequestBody User user, HttpSession session) {
        JSONObject res = new JSONObject();
        try {
            User user1 = (User) session.getAttribute("user");   // 获取登陆用户信息
            if (user1 != null){
                user.setCreator(user1.getName());
            }else{
                user.setCreator("未登陆");
            }
            userService.add(user);
            res.put("status", "success");
            res.put("message", "新增成功！");
        } catch (Exception e) {
            e.printStackTrace();
            res.put("status", "fail");
            res.put("message", "新增失败！");
        }
        return res.toString();
    }

    /**
     * 根据ID删除用户
     *
     * @param user
     * @return
     */
    @RequestMapping("/deleteUserById/{id}")
    public ModelAndView deleteUserById(User user) {
        userService.deleteUserById(user.getId());
        ModelAndView mav = new ModelAndView("redirect:/accountManage");
        return mav;
    }

    /**
     * 根据ID获取用户
     *
     * @param user
     * @return
     */
    @RequestMapping("getUserById")
    @ResponseBody
    public String getUserById(Integer id) {
        JSONObject res = new JSONObject();
        try {
            User user1 = userService.getUserById(id);
            JSONObject data = JSONObject.fromBean(user1);
            res.put("status", "success");
            res.put("message", "获取信息成功");
            res.put("data", data);
        } catch (Exception e) {
            e.printStackTrace();
            res.put("status", "fail");
            res.put("message", "获取信息失败");
        }
        return res.toString();
    }

    /**
     * 修改用户数据
     *
     * @param user
     * @return
     */
    @RequestMapping("updateUserById")
    @ResponseBody
    public String updateUserById(@RequestBody User user,HttpSession session) {
        JSONObject res = new JSONObject();
        try {
            if(user != null && user.getId() == 0){
                User user1 = (User) session.getAttribute("user");   // 获取登陆用户信息
                user.setId(user1.getId());
            }
            userService.updateUserById(user);
            res.put("status", "success");
            res.put("message", "修改成功！");
        } catch (Exception e) {
            e.printStackTrace();
            res.put("status", "fail");
            res.put("message", "修改失败！");
        }
        return res.toString();
    }

    /**
     * 检验账号是否存在
     *
     * @param userName
     * @return
     */
    @RequestMapping("checkUserNameIsExist")
    @ResponseBody
    public String checkUserNameIsExist(String userName) {
        JSONObject res = new JSONObject();
        try {
            boolean data = userService.checkUserNameIsExist(userName);
            res.put("status", "success");
            res.put("message", "账号是否存在检验成功！");
            res.put("data", data);
        } catch (Exception e) {
            e.printStackTrace();
            res.put("status", "fail");
            res.put("message", "账号是否存在检验失败！");
        }
        return res.toString();
    }

    /**
     * 跳转至登录页面
     *
     * @param
     * @return
     */
    @RequestMapping("/signin")
    public ModelAndView jumpToSignin() {
        ModelAndView mav = new ModelAndView("/signin");
        return mav;
    }

    /**
     * 跳转至个人账号管理页面
     *
     * @param
     * @return
     */
    @RequestMapping("/account")
    public ModelAndView jumpToAccount(HttpSession session) {
        User user1 = (User) session.getAttribute("user");   // 获取登陆用户信息
        ModelAndView mav = new ModelAndView("/account");
        if(user1 != null){  // 如果信息存在则传递
            mav.addObject("user",user1);
        }else{  // 如果不存在则返回登录页面
            mav.setViewName("/signin");
        }
        return mav;
    }

    /**
     * 根据父类ID获取基础数据
     * @return
     */
    @RequestMapping("getDataDictionaryByParentId")
    @ResponseBody
    public String getDataDictionaryByParentId(String parentId) {
        JSONObject res = new JSONObject();
        try {
            List<DataDictionaryItem> dataList = dataDictionaryService.getDataDictionaryByParentId(parentId);
            JSONArray dataList1 = JSONArray.fromArray(dataList.toArray(new DataDictionaryItem[dataList.size()]));
            res.put("dataList", dataList1);

            res.put("status", "success");
            res.put("message", "下拉框数据获取成功!");
        } catch (Exception e) {
            e.printStackTrace();
            res.put("status", "fail");
            res.put("message", "下拉框数据获取失败！");
        }
        // 返回结果
        return res.toString();
    }
}
