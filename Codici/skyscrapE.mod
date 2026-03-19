set M circular; #Months


param demand{M}; #demand for each month
param c_arrive;  #cost to bring a worker
param c_leave;   #cost of letting a worker go
param c_staffing; #cost of over/understaffing
param h_init; #workers present at the end of February
param first_month symbolic in M; # = 'February'


var x{i in M} integer >= 0, <= 3;
var y{i in M} integer >= 0;
var h{i in M} integer;
var o{i in M} integer >= 0;
var u{i in M} integer >= 0; 


minimize f: sum{j in M} (x[j] * c_arrive + y[j] * c_leave + (o[j] + u[j]) * c_staffing);
	
s.t. left_worker{j in M}: h[j] = 
	(if j = first_month then h_init else h[prev(j,M)])
	 + x[j] - y[j];

s.t. max_leave_worker{j in M}: y[j] <= 
    ( (if j = first_month then h_init else h[prev(j,M)]) 
	+ x[j]) / 3;

s.t. overstaffing{j in M}: 
	(if j = first_month then h_init else h[prev(j,M)])
	+ x[j] - demand[j] <= o[j];
 
s.t. understaffing{j in M}: 
	demand[j] - x[j] -
	(if j = first_month then h_init else h[prev(j,M)])
	<= u[j];

s.t. max_overtime{j in M}: demand[j] <= 1.25 * (x[j] + 
	(if j = first_month then h_init else h[prev(j,M)])
	);

s.t. last_worker_present: h[last(M)] = 3;

