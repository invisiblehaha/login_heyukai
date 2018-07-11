package cn.vision.invicloud.web.controller.system;

import cn.vision.invicloud.support.entity.Customer;
import cn.vision.invicloud.support.service.ICustomerService;
import com.google.code.kaptcha.Producer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpServletRequest;
import java.util.Base64;
import humanfaceAPI.*;
import java.util.Calendar;
import java.util.Date;


@Controller
@RequestMapping("register/register")
public class RegisterController {
/*
    protected Logger logger = LoggerFactory.getLogger(RegisterController.class);
    //register的日志

    @Autowired
    private Producer captchaProducer;

    @Autowired
    private HttpServletRequest request;
*/

    @Autowired
    private ICustomerService customerService;

    @GetMapping(value = "/view")
    public String getRegisterPage(Model model)
    {
        return "/register/register";
    }


    final Base64.Decoder decoder = Base64.getDecoder();
    public byte[] Base64ToByteArr(String b64)
    {
        String[] strArr=b64.split(",");
        return decoder.decode(strArr[1]);
    }

    /**
     * POST 注册信息
     */
    @PostMapping(value = "/register")
    @ResponseBody
    public void register(@RequestParam("userName")String registerName,
                        @RequestParam("password")String registerPassword,
                        @RequestParam("sex")Integer sex, //0==保密 1==男 2==女
                        @RequestParam("birthYear")Integer birthYear,
                        @RequestParam("phoneNumber")String phoneNumber,
                        @RequestParam("img")String imgString)
    {
        byte[] buff=Base64ToByteArr(imgString);
        String detectToken = InterfaceOfAllAPIs.detect(buff);

        Calendar cal = Calendar.getInstance();

        Integer theCustomerId = customerService.getLastestPlusCustomerId()+1;//从数据库中获取最新的id + 1,即预备绑定给用户的id

        Customer customer = new Customer();
        customer.setCustomerId(theCustomerId);
        customer.setCustomerToken(detectToken);
        customer.setAge(cal.get(Calendar.YEAR)-birthYear);
        customer.setPicImg("picImg");
        customer.setNoble(1);
        customer.setRealName(registerName);
        customer.setRegeistTime(new Date());
        customer.setSex(sex);
        customer.setStatus(0);
        customer.setTelephone(phoneNumber);

        try
        {
            String addLog = InterfaceOfAllAPIs.addOneFaceIntoFaceSet(detectToken,"FS_1");
            String bindLog = InterfaceOfAllAPIs.setUserIdForFaceToken(detectToken,Integer.toString(theCustomerId));
            System.out.println(addLog);
        }
        catch(Exception e)
        {
            System.out.println("添加到人脸集合出错!");
        }

        try
        {
            customerService.insertCustomer(customer);
           /* System.out.println(insertResult);//调试用，如果系统运行正常请删除*/
        }
        catch(Exception e)
        {
            System.out.println("数据库操作异常！");
        }



    }



}
