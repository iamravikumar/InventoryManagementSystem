using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Rule
/// </summary>
/// 

public class InputRule
{
    private String elementName = null;
    private bool required = false;
    private int maxLength = 0;
    private int minLength = 0;
    private String rule;
    private String errMsg = null;
    private InputRangeValidator range = null;
    private String equalWith = null;
    public static readonly String ALPHABET_WITH_SPACE = @"^[a-zA-Z\s]+$";
    public static readonly String ALPHABET_NO_SPACE = @"^[a-zA-Z][a-zA-Z\\s]+$";
    public static readonly String ALPHA_NUMERIC_NO_SPACE = @"^[a-zA-Z0-9]+$";
    public static readonly String ALPHA_NUMERIC_WITH_SPACE = @"^[a-zA-Z0-9 ]+$";
    public static readonly String USER_NAME = @"^[a-zA-Z0-9_.]+$";
    public static readonly String DATE_SLASH = @"^(((0[1-9]|[12]\d|3[01])\/(0[13578]|1[02])\/((19|[2-9]\d)\d{2}))|((0[1-9]|[12]\d|30)\/(0[13456789]|1[012])\/((19|[2-9]\d)\d{2}))|((0[1-9]|1\d|2[0-8])\/02\/((19|[2-9]\d)\d{2}))|(29\/02\/((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))))$";
    public static readonly String DATE_HYPHEN = @"^(((0[1-9]|[12]\d|3[01])\-(0[13578]|1[02])\-((19|[2-9]\d)\d{2}))|((0[1-9]|[12]\d|30)\-(0[13456789]|1[012])\-((19|[2-9]\d)\d{2}))|((0[1-9]|1\d|2[0-8])\-02\-((19|[2-9]\d)\d{2}))|(29\-02\-((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))))$";
    public static readonly String DIGITS = @"^[0-9]+$";
    public static readonly String NONZERODIGITS = @"^[1-9]+$";
    public static readonly String DECIMAL = @"^[0-9.]+$";
    public static readonly String NONZERODECIMAL = @"^[1-9.]+$";
    public static readonly String EMAIL = @"^((([\w]+\.[\w]+)+)|([\w]+))@(([\w]+\.)+)([A-Za-z]{1,3})$";
    public static readonly String MOBILE = @"^[0-9]{10}$";
    public static readonly String ALL = ".*";

    public InputRule(String regex)
    {
        this.rule = regex;
    }

    public String GetRule()
    {
        return rule;
    }

    public void SetErrorMsg(String errMsg)
    {
        this.errMsg = errMsg;
    }

    public String GetErrorMsg()
    {
        return errMsg;
    }

    public void SetElementName(String elementName)
    {
        this.elementName = elementName;
    }

    public String GetElementName()
    {
        return elementName;
    }

    public void SetRequired(bool required)
    {
        SetErrorMsg(GetElementName().Replace('_', ' ').ToUpper() + " is mandatory.");
        this.required = required;
    }

    public bool GetRequired()
    {
        return required;
    }

    public void SetMinLength(int minLength)
    {
        SetErrorMsg("Minimum length of " + GetElementName().Replace('_', ' ').ToUpper() + " is " + minLength + ".");
        this.minLength = minLength;
    }

    public int GetMinLength()
    {
        return minLength;
    }

    public void SetMaxLength(int maxLength)
    {
        SetErrorMsg("Maximum length of " + GetElementName().Replace('_', ' ').ToUpper() + " is " + maxLength + ".");
        this.maxLength = maxLength;
    }

    public int GetMaxLength()
    {
        return maxLength;
    }

    public void SetEqualWith(String equalWith)
    {
        SetErrorMsg("Value of " + GetElementName().Replace('_', ' ').ToUpper() + " must be matched with " + equalWith + ".");
        this.equalWith = equalWith;
    }

    public String GetEqualWith()
    {
        return equalWith;
    }

    public void SetRangeValidator(InputRangeValidator range)
    {
        this.range = range;
    }

    public InputRangeValidator GetRangeValidator()
    {
        return range;
    }

}