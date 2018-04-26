#include <iostream>
#include <vector>
#include <cstdlib>
#include <string>
#include <stdexcept>
 
using namespace std;
 
template <class T>
class Stack { 
  private: 
    vector<T> elems;     
 
  public: 
    /* entry stack */
    void push(T const&);  
    /* exit stack */
    void pop();              
    T top() const;         
    bool empty() const{    
        return elems.empty(); 
    } 
}; 
 
template <class T>
void Stack<T>::push (T const& elem) 
{ 
    /* add element backup */
    elems.push_back(elem);    
} 
 
template <class T>
void Stack<T>::pop () 
{ 
    if (elems.empty()) { 
        throw out_of_range("Stack<>::pop(): empty stack"); 
    }
    /* delete last element */
    elems.pop_back();         
} 
 
template <class T>
T Stack<T>::top () const 
{ 
    if (elems.empty()) { 
        throw out_of_range("Stack<>::top(): empty stack"); 
    }
    /* return last elements's backup */
    return elems.back();      
} 
 
int main() 
{ 
    try { 
        /* int stack */
        Stack<int>         intStack;  
        /* string stack */
        Stack<string> stringStack;    
 
        intStack.push(7); 
        cout << intStack.top() <<endl; 
 
        stringStack.push("hello"); 
        cout << stringStack.top() << std::endl; 
        stringStack.pop(); 
        stringStack.pop(); 
    } 
    catch (exception const& ex) { 
        cerr << "Exception: " << ex.what() <<endl; 
        return -1;
    } 
}
