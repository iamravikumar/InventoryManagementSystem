using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Collections;
using System.Text.RegularExpressions;

/// <summary>
/// Summary description for Validator
/// </summary>
/// 

public class InputValidator
{
    private HttpRequest request;
    private Hashtable rules;
    private Hashtable errors;

    public InputValidator(HttpRequest request)
    {
        this.request = request;
        rules = new Hashtable(StringComparer.InvariantCultureIgnoreCase);
        errors = new Hashtable(StringComparer.InvariantCultureIgnoreCase);
    }

    public void Add(String elementName, bool required, String regex)
    {
        InputRule r = new InputRule(regex);
        r.SetElementName(elementName);
        r.SetRequired(required);
        rules.Add(elementName, r);
    }

    public void Add(String elementName, bool required, String regex, InputRangeValidator range)
    {
        InputRule r = new InputRule(regex);
        r.SetElementName(elementName);
        r.SetRequired(required);
        r.SetRangeValidator(range);
        rules.Add(elementName, r);
    }

    public void Add(String elementName, bool required, String regex, int maxLength)
    {
        InputRule r = new InputRule(regex);
        r.SetElementName(elementName);
        r.SetRequired(required);
        r.SetMaxLength(maxLength);
        rules.Add(elementName, r);
    }
    public void Add(String elementName, bool required, String regex, int maxLength, int minLength)
    {
        InputRule r = new InputRule(regex);
        r.SetElementName(elementName);
        r.SetMaxLength(maxLength);
        r.SetMinLength(minLength);
        r.SetRequired(required);
        rules.Add(elementName, r);
    }

    public void Add(String elementName, bool required, InputRule InputRule)
    {
        InputRule.SetElementName(elementName);
        InputRule.SetRequired(required);
        rules.Add(elementName, InputRule);
    }
    public void Add(String elementName, bool required, InputRule InputRule, int maxLength)
    {
        InputRule.SetElementName(elementName);
        InputRule.SetRequired(required);
        InputRule.SetMaxLength(maxLength);
        rules.Add(elementName, InputRule);
    }
    public void Add(String elementName, bool required, InputRule InputRule, int maxLength, int minLength)
    {
        InputRule.SetElementName(elementName);
        InputRule.SetRequired(required);
        InputRule.SetMaxLength(maxLength);
        InputRule.SetMinLength(minLength);
        rules.Add(elementName, InputRule);
    }
    
    public bool Validate()
    {
        bool flag = true;
        foreach (string s in rules.Keys)
        {
            InputRule r = (InputRule)rules[s];
            if (request[r.GetElementName()] != null)
            {
                String value = request[r.GetElementName()];
                int len = value.Trim().Length;
                String errorMsg = r.GetErrorMsg() == null ? "" : r.GetErrorMsg();
                String equalWith = r.GetEqualWith() == null ? null : request[r.GetEqualWith()] == null ? null : request[r.GetEqualWith()];
                String pattern = r.GetRule() == null ? InputRule.ALL : r.GetRule();
                errors.Add(r.GetElementName(), errorMsg);
                if (r.GetRequired() && len == 0)
                {
                    flag = false;
                    continue;
                }
                if (r.GetRequired() == false && len == 0)
                {
                    errors.Remove(r.GetElementName());
                    continue;
                }
                if (r.GetMinLength() != 0 && len < r.GetMinLength())
                {
                    flag = false;
                    continue;
                }
                if (r.GetMaxLength() != 0 && len > r.GetMaxLength())
                {
                    flag = false;
                    continue;
                }
                if (r.GetMaxLength() != 0 && len > r.GetMaxLength())
                {
                    flag = false;
                    continue;
                }
                if (equalWith != null && value != equalWith)
                {
                    flag = false;
                    continue;
                }
                if (Regex.IsMatch(value, r.GetRule()) == false && len > 0)
                {
                    flag = false;
                    continue;
                }
                if (r.GetRangeValidator()!=null)
                {
                    if (!r.GetRangeValidator().Validate(value))
                    {
                        flag = false;
                        continue;
                    }
                }
                errors.Remove(r.GetElementName());
            }
        }
        return flag;
    }

    public Hashtable GetErrors()
    {
        return errors;
    }

}